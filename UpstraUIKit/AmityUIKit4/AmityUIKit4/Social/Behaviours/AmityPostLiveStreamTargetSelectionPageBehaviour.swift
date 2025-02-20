//
//  AmityPostLiveStreamTargetSelectionPageBehaviour.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 16/11/2567 BE.
//

import Foundation
import UIKit

open class AmityPostLiveStreamTargetSelectionPageBehaviour {

    open class Context {
        public let page: AmityPostLiveStreamTargetSelectionPage
        public let community: AmityCommunityModel?

        init(page: AmityPostLiveStreamTargetSelectionPage, community: AmityCommunityModel?) {
            self.page = page
            self.community = community
        }
    }

    public init() {}

    open func goToPostComposerPage(context: AmityPostLiveStreamTargetSelectionPageBehaviour.Context) {
        AmityUIKit4EventHandler.shared.createLiveStreamPost(from: context.page.host.controller ?? UIViewController(), targetId: context.community == nil ? nil : (context.community?.communityId ?? ""), targetType: context.community == nil ? .user : .community, destinationToUnwindBackAfterFinish: context.page.host.controller?.presentingViewController ?? UIViewController())
    }

}
