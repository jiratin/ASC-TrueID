//
//  URLEnpointManager.swift
//  Potioneer
//
//  Created by Thavorn Kamolsin on 2/11/2567 BE.
//

import Foundation

struct DomainManager {
    
    static var domainAPITrueIDPopularFeed: String {
        switch AmityUIKitManagerInternal.shared.trueIDEnvType {
        case .production:
            if AmityUIKitManagerInternal.shared.currentUserId.contains("anonymous") {
                return "https://community-public-api.trueid.net"
            } else {
                return "https://community-customer-api.trueid.net"
            }
        case .preproduction, .staging, .uat:
            if AmityUIKitManagerInternal.shared.currentUserId.contains("anonymous") {
                return "https://community-public-api.trueid-preprod.net"
            } else {
                return "https://community-customer-api.trueid-preprod.net"
            }
        case .none:
            return "";
        }
    }
    
    static var domainAPIAmityGetLiveStream: String {
        switch AmityUIKitManagerInternal.shared.trueIDEnvType {
        case .production:
            return "https://cpvp6wy03k.execute-api.ap-southeast-1.amazonaws.com"
        case .preproduction, .staging, .uat:
            return "https://trueid-service-stg.amity.services"
        case .none:
            return "";
        }
    }
    
    
}

