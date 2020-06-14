//
//  DTO.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import UIKit

struct ErrorResponseDTO: Decodable {
}

struct TokenDTO: Decodable {
    let token: String
}

struct UsernameDTO: Decodable {
    let username: String?
}

struct EmailDTO: Encodable {
    let email: String
}

struct LoginDTO: Decodable {
    let token: String
    let user: UserDTO
}

struct AuthenticationDTO: Encodable {
    var email: String? = nil
    var phoneNumber: String? = nil
    var username: String? = nil
    var facebookId: String? = nil
    var appleId: String? = nil
    let password: String
}

struct UserDTO: Codable {
    let _id: String
    let email: String?
    var username: String?
    let inRoom: String?
    var isSharingLocation: Bool?
    var artist: ArtistDTO?
    let agoraId: UInt
    var picture: String?
    var latitude: Double?
    var longitude: Double?
    var language: String?
    var favArtists: [String]?
}

struct ArtistDTO: Codable {
    let _id: String?
    var name: String?
    var picture: String?
    let description: String?
    let socialMedias: [SocialMediaDTO]?
}

struct RoomDTO: Decodable {
    let id: String
    let owner: String?
    let event: String?
    let participants: [RoomParticipantsDTO]?
}

struct RoomParticipantsDTO: Decodable {
    let _id: String
}

struct EventList: Decodable {
    let eventList: [EventDTO]
}

struct EventDTO: Codable {
    let _id: String
    let name: String
    let artist: ArtistDTO
    let date: String
    let createdAt: String
    let length: Int
    let state: String?
    let picture: String?
    let streamId: String?
    let ticket_type: String?
    let description: String?
    let participants: Int?
    let participantsOnline: Int?
    let banlist: [String]?
    let placeholdersImg: [String]?
}

enum eState: String {
    case NOT_STARTED = "NOT_STARTED"
    case ROOMS = "ROOMS"
    case SAS = "SAS"
    case LIVE = "LIVE"
    case OVER = "OVER"
    
    static func convertStringToEnum(_ value: String?) -> eState? {
        switch value {
        case eState.NOT_STARTED.rawValue:
            return eState.NOT_STARTED
        case eState.ROOMS.rawValue:
            return eState.ROOMS
        case eState.SAS.rawValue:
            return eState.SAS
        case eState.LIVE.rawValue:
            return eState.LIVE
        case eState.OVER.rawValue:
            return eState.OVER
        default:
            return nil
        }
    }
}

struct SongDTO: Decodable {
    let _id: String?
    let url: String?
    let title: String?
}

struct VideoDTO: Decodable {
    let _id: String?
    let url: String?
    let title: String?
}

enum eSocialMedia: String {
    case Twitter = "Twitter"
    case Instagram = "Instagram"
    case Facebook = "Facebook"
    case Snapshat = "Snapshat"
    case Web = "Web"
    case Merch = "Merch"
    case Soundcloud = "Soundcloud"
    case Bandcamp = "Bandcamp"
    case Bandintown = "Bandintown"
    
    static func convertStringToEnum(_ value: String?) -> eSocialMedia? {
        switch value {
        case eSocialMedia.Twitter.rawValue:
            return eSocialMedia.Twitter
        case eSocialMedia.Instagram.rawValue:
            return eSocialMedia.Instagram
        case eSocialMedia.Facebook.rawValue:
            return eSocialMedia.Facebook
        case eSocialMedia.Snapshat.rawValue:
            return eSocialMedia.Snapshat
        case eSocialMedia.Web.rawValue:
            return eSocialMedia.Web
        case eSocialMedia.Merch.rawValue:
            return eSocialMedia.Merch
        case eSocialMedia.Soundcloud.rawValue:
            return eSocialMedia.Soundcloud
        case eSocialMedia.Bandcamp.rawValue:
            return eSocialMedia.Bandcamp
        case eSocialMedia.Bandintown.rawValue:
            return eSocialMedia.Bandintown
        default:
            return nil
        }
    }
    
    func getPicture() -> UIImage? {
        switch self {
        case eSocialMedia.Twitter:
            return #imageLiteral(resourceName: "iconTwitterFull")
        case eSocialMedia.Instagram:
            return #imageLiteral(resourceName: "iconInstagram")
        case eSocialMedia.Facebook:
            return #imageLiteral(resourceName: "iconFacebookFull")
        case eSocialMedia.Snapshat:
            return #imageLiteral(resourceName: "iconSnapchat")
        case eSocialMedia.Web:
            return #imageLiteral(resourceName: "iconWebsite")
        case eSocialMedia.Merch:
            return #imageLiteral(resourceName: "iconShop")
        case eSocialMedia.Soundcloud:
            return #imageLiteral(resourceName: "iconSoundcloud")
        case eSocialMedia.Bandcamp:
            return #imageLiteral(resourceName: "iconBandcamp")
        case eSocialMedia.Bandintown:
            return #imageLiteral(resourceName: "iconBandintown")
        }
    }
}

struct SocialMediaDTO: Codable {
    let _id: String?
    let url: String?
    let name: String?
}

struct TicketDTO: Decodable {
    let _id: String
    let event: String
    let user: String
    let event_over: Bool
}

struct FileWrapperDto {
    let fileName: String
    let fileNameField: String
    let data: Data
}

struct ArtistEventRoomsDTO: Decodable {
    let owner: UserDTO
    let id: String
    let participants: [UserDTO]
}

struct ParticipantOnlineDTO: Decodable {
    let participantsOnline: Int
    let participants: Int
}

struct NotificationTokenDTO: Encodable {
    let token: String
    let type: String = "IOS"
}
