//
//  TrueIDCountry.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 2/11/2567 BE.
//

public enum TrueIDCountryType: String, Codable, CaseIterable {
   
    case thailand
    case indonesia
    case cambodia
    case philippin
    case vietnam
    case myanmar
    case none
    
    var title: String {
        switch self {
        case .thailand:
            return "Thailand"
        case .indonesia:
            return "Indonesia"
        case .cambodia:
            return "Cambodia"
        case .philippin:
            return "Philippin"
        case .vietnam:
            return "Vietnam"
        case .myanmar:
            return "Myanmar"
        case .none:
            return ""
        }
    }
}
