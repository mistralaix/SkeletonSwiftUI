//
//  WebService.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation

class WebService {
    
    // MARK: Constants
    
    enum Consts {
        
        static let LogDebug = true
        
        static let DefaultRequestTimeout: TimeInterval = 15.0
        
        static let AuthorizationHeader = "Authorization"
        static let ContentTypeHeader = "Content-Type"
        static let AcceptHeader = "Accept"
        static let JsonContentType = "application/json"
         
        static let AuthenticateURL = "/login"
        static let notificationURL = "/notifications"
    }
    
    // MARK: Init
    
    private init() {
        defaultURLSessionConfiguration = .default
        defaultURLSessionConfiguration.timeoutIntervalForRequest = Consts.DefaultRequestTimeout
        defaultURLSessionConfiguration.httpAdditionalHeaders = [Consts.AcceptHeader: Consts.JsonContentType, Consts.ContentTypeHeader: Consts.JsonContentType]
        
        standardSession = URLSession(configuration: defaultURLSessionConfiguration, delegate: nil, delegateQueue: .main)
        // Init the session without authorization header
        authenticatedSession = URLSession(configuration: defaultURLSessionConfiguration, delegate: nil, delegateQueue: .main)
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
        
        if let token = KeychainManager.shared.getToken() {
            self.initAuthenticatedSession(with: "Bearer \(token)")
        }
    }
    
    // MARK: Public Properties
    
    static let shared = WebService()
    
    // MARK: Private Properties
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private let defaultURLSessionConfiguration: URLSessionConfiguration
    private let standardSession: URLSession
    private var authenticatedSession: URLSession
    
    // MARK: Public Methods
    
    private func saveLoginInfo(_ authent: AuthenticationDTO, _ data: LoginDTO?) {
        if let tokenData = data {
            KeychainManager.shared.saveCredentials(email: authent.email ?? "", password: authent.password, token: tokenData.token)
            self.initAuthenticatedSession(with: "Bearer \(tokenData.token)")
        } else {
            KeychainManager.shared.clearCredentials()
        }
    }
    
    func authenticate(authent: AuthenticationDTO, completion: @escaping (LoginDTO?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        // swiftlint:disable:next force_try
        let requestURL = String(format: Consts.AuthenticateURL)
        let body = try! encoder.encode(authent)
        
        postDataTask(requestURL, body: body, completion: { (data: LoginDTO?, webServiceResponse, err) in
            self.saveLoginInfo(authent, data)
            completion(data, webServiceResponse, nil)
        })
    }
    
    func postTokenAPNS(token: NotificationTokenDTO, completion: @escaping(NoContentData?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        let requestURL = String(format: Consts.notificationURL)
        let body = try! encoder.encode(token)

        postDataTask(requestURL, body: body, requiresAuthentication: true, completion: completion)
    }
    
    // MARK: Private Methods
    
    private func initAuthenticatedSession(with authorizationHeader: String) {
        defaultURLSessionConfiguration.httpAdditionalHeaders?[Consts.AuthorizationHeader] = authorizationHeader
        authenticatedSession = URLSession(configuration: defaultURLSessionConfiguration, delegate: nil, delegateQueue: .main)
    }
    
    private func getDataTask<T: Decodable>(_ stringURL: String, requiresAuthentication: Bool = false, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        dataTask(stringURL, body: nil, httpMethod: "GET", requiresAuthentication: requiresAuthentication, completion: completion)
    }
    
    private func postDataTask<T: Decodable>(_ stringURL: String, body: Data?, requiresAuthentication: Bool = false, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        dataTask(stringURL, body: body, httpMethod: "POST", requiresAuthentication: requiresAuthentication, completion: completion)
    }
    
    private func putDataTask<T: Decodable>(_ stringURL: String, body: Data?, requiresAuthentication: Bool = false, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        dataTask(stringURL, body: body, httpMethod: "PUT", requiresAuthentication: requiresAuthentication, completion: completion)
    }
    
    private func patchDataTask<T: Decodable>(_ stringURL: String, body: Data?, requiresAuthentication: Bool = false, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        dataTask(stringURL, body: body, httpMethod: "PATCH", requiresAuthentication: requiresAuthentication, completion: completion)
    }
    
    private func deleteDataTask<T: Decodable>(_ stringURL: String, body: Data?, requiresAuthentication: Bool = true, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        dataTask(stringURL, body: body, httpMethod: "DELETE", requiresAuthentication: requiresAuthentication, completion: completion)
    }
    
    private func dataTask<T: Decodable>(_ stringURL: String, body: Data?, httpMethod: String, requiresAuthentication: Bool, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "\(Config.ROOT_URL)\(stringURL)")!)
        
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = body
        
        process(urlRequest: urlRequest, requiresAuthentication: requiresAuthentication, canRetryOnUnauthorized: true, completion: completion)
    }
    
    private func dataTask<T: Decodable>(file: FileWrapperDto, url: String, method: String, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
//        var request = URLRequest(url: url)
        var request = URLRequest(url: URL(string: "\(Config.ROOT_URL)\(url)")!)
        request.httpMethod = method
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: Consts.ContentTypeHeader)
        
        let body = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition:form-data; name=\"\(file.fileNameField)\";filename=\"\(file.fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(file.data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        process(urlRequest: request, requiresAuthentication: true, canRetryOnUnauthorized: true, completion: completion)
    }
    
    private func process<T: Decodable>(urlRequest: URLRequest, requiresAuthentication: Bool, canRetryOnUnauthorized: Bool, completion: @escaping (T?, WebServiceResponse, ErrorResponseDTO?) -> Void) {
        if Consts.LogDebug {
            print("Calling \(urlRequest)")
//            dump(urlRequest)
            if let body = urlRequest.httpBody, let bodyStr = String(data: body, encoding: .utf8) {
                print("with body: \(bodyStr)")
            }
        }
        let session = requiresAuthentication ? authenticatedSession : standardSession
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if Consts.LogDebug {
                let readableData = String(data: data ?? Data(), encoding: .utf8) ?? "no data"
                print("Data \(readableData) Response \(String(describing: response)) Error \(String(describing: error))")
            }
            let webServiceResponse = WebServiceResponse(rawData: data, response: response, error: error)
            if error == nil && webServiceResponse.isSuccess, let data = data, webServiceResponse.statusCode != 204 {
                do {
                    let typedData = try self.decoder.decode(T.self, from: data)
                    completion(typedData, webServiceResponse, nil)
                    return
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            } else if webServiceResponse.statusCode == 400, let data = data {
                
                do {
                    let typedData = try self.decoder.decode(ErrorResponseDTO.self, from: data)
                    completion(nil, webServiceResponse, typedData)
                    return
                } catch {
                    
                }
                
            } else if webServiceResponse.statusCode == 401 && requiresAuthentication && canRetryOnUnauthorized,
                let (email, password) = KeychainManager.shared.getCredentials() {
                // Token has expired, refreshing
                self.authenticate(authent: AuthenticationDTO(email: email, password: password), completion: { (_, authResponse, err) in
                    switch authResponse.statusCode {
                    case 200:
                        self.process(urlRequest: urlRequest, requiresAuthentication: requiresAuthentication, canRetryOnUnauthorized: false, completion: completion)
                    case 401:
                        // TODO: The login/password is no longer valid, we need to disconnect the user
                        completion(nil, webServiceResponse, nil)
                        break
                    default:
                        completion(nil, webServiceResponse, nil)
                    }
                })
                return
            }
            completion(nil, webServiceResponse, nil)
        }
        task.resume()
    }
    
}

class WebServiceResponse {
    let rawData: Data?
    let response: URLResponse?
    let error: Error?
    let statusCode: Int?
    
    var isSuccess: Bool {
        if let statusCode = statusCode, case 200...299 = statusCode {
            return true
        }
        return false
    }
    
    init(rawData: Data?, response: URLResponse?, error: Error?) {
        self.rawData = rawData
        self.response = response
        self.error = error
        statusCode = (response as? HTTPURLResponse)?.statusCode
    }
}

struct NoContentData: Decodable {
}
