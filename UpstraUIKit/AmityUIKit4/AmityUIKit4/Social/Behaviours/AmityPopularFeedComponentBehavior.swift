//
//  AmityPopularFeedComponentBehavior.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 4/11/2567 BE.
//
import Foundation

open class AmityPopularFeedComponentBehavior {
    
    open class Context {
        public let component: AmityPopularFeedComponent
        public let post: AmityPostModel
        
        init(component: AmityPopularFeedComponent, post: AmityPostModel) {
            self.component = component
            self.post = post
        }
    }
    
    public init() {}
    
    open func goToPostDetailPage(context: AmityPopularFeedComponentBehavior.Context) {
        let vc = AmitySwiftUIHostingController(rootView: AmityPostDetailPage(post: context.post.object, category: context.post.isPinned ? .global : .general))
        let host = context.component.host
        host.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
