//
//  AmityUIKit4EventHandler.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 16/11/2567 BE.
//

import AmitySDK
import UIKit

open class AmityUIKit4EventHandler {
    static var shared = AmityUIKit4EventHandler()

    public init() {}
    
    /// This function will triggered when the user choose to "create live stream post".
    ///
    /// - Parameters:
    ///   - source: The source view controller that trigger the event.
    ///   - targetId: The target id to create live stream post.
    ///   - targetType: The target type to create live stream post.
    ///   - destinationToUnwindBackAfterFinish: The view controller to unwind back when live streaming has done. To maintain the proper AmityUIKit flow, please dismiss to this view controller after the action has ended.
    open func createLiveStreamPost(
        from source: UIViewController,
        targetId: String?,
        targetType: AmityPostTargetType,
        destinationToUnwindBackAfterFinish: UIViewController
    ) {
        print("To present live stream post creator, please override \(AmityUIKit4EventHandler.self).\(#function), see https://docs.amity.co for more details.")
    }

    
}
