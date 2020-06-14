//
//  AppDataManager.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation

class AppDataManager {
    
    static let shared = AppDataManager()
    
    var user: UserDTO?
    var allEvents = [EventDTO]()
    
    var finishFetchingCb: (() -> Void)?
    
    private var hasFetch = 0 {
        didSet {
            hasFetch = oldValue + 1
            if hasFetch == nbFunctionCalled {
                hasFetch = 0
                nbFunctionCalled = 0
                self.finishFetchingCb?()
            }
        }
    }
    private var nbFunctionCalled = 0
    
    func getMyProfile(completion: ((LoginDTO?) -> Void)?) {
        guard let (auth, authMethod) = KeychainManager.shared.getCredentials() else {
            completion?(nil)
            return
        }
        nbFunctionCalled += 1
        WebService.shared.authenticate(authent: auth, authentMethod: authMethod) { (object, response, error) in
            guard let obj = object else {
                self.hasFetch = 1
                completion?(nil)
                return
            }
            self.user = obj.user
            self.hasFetch = 1
            completion?(obj)
        }
    }
    
    func getEvents(completion: (([EventDTO]?) -> Void)?) {
        nbFunctionCalled += 1
        WebService.shared.getEvents { (object, response, error) in
            guard let obj = object else {
                self.hasFetch = 1
                completion?(nil)
                return
            }
            self.allEvents = obj.eventList
            self.hasFetch = 1
            completion?(self.allEvents)
        }
    }
    
    func getData(completion: ((UserDTO?) -> Void)?) {
        self.finishFetchingCb = {
            completion?(self.user)
        }
        self.getMyProfile(completion: nil)
        self.getEvents(completion: nil)
    }
    
}
