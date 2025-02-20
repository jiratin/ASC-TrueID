//
//  EnvType.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 2/11/2567 BE.
//

public enum TrueIDEnvironmentType: String, Codable, CaseIterable {
   
    case production
    case preproduction
    case uat
    case staging
    case none
    
    var title: String {
        switch self {
        case .production:
            return "Production"
        case .preproduction:
            return "Pre-Production"
        case .uat:
            return "UAT"
        case .staging:
            return "Staging"
        default:
            return ""
        }
    }
}
