//
//  AmityMyCommunitiesHeaderComponentBehavior.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 8/11/2567 BE.
//

import Foundation

open class AmityMyCommunitiesHeaderComponentBehavior {
    open class Context {
        public let component: MyCommunityHeadeComponent
        let communityId: String?
        
        init(component: MyCommunityHeadeComponent,communityId: String? = nil) {
            self.component = component
            self.communityId = communityId
        }
    }
    
    public init() {}
    
    
    open func goToCommunityProfilePage(context: AmityMyCommunitiesHeaderComponentBehavior.Context) {
        
        guard let communityId = context.communityId else { return }
        
        let communityProfilePage = AmityCommunityProfilePage(communityId: communityId)
        let controller = AmitySwiftUIHostingController(rootView: communityProfilePage)
        controller.navigationController?.isNavigationBarHidden = true
        
        context.component.host.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    open func goToMyCommunitys(context: AmityMyCommunitiesHeaderComponentBehavior.Context) {
        let myCommunitysPAge = AmityMyCommunitiesComponent(pageId: PageId.myCommunitiesSearchPage, isShowNavigationBar: true)
        let controller = AmitySwiftUIHostingController(rootView: myCommunitysPAge)
        controller.navigationController?.isNavigationBarHidden = true
        context.component.host.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
