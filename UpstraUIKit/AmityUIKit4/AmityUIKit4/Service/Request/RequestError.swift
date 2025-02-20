//
//  RequestError.swift
//  Potioneer
//
//  Created by Thavorn Kamolsin on 2/11/2567 BE.
//

import Foundation

protocol OurErrorProtocol: LocalizedError {

    var errorMessage: String { get }
    var errorCode: Int { get }
}

struct RequestError:OurErrorProtocol {
    
    let errorCode: Int
    let errorMessage: String
    
    init(errorCode: Int = 0, errorMessage: String = "") {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
    
}
