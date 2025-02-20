//
//  FeedManager.swift
//  AmityUIKit4
//
//  Created by Zay Yar Htun on 5/7/24.
//

import Foundation
import AmitySDK

class FeedManager {
    private let feedRepository = AmityFeedRepository(client: AmityUIKitManagerInternal.shared.client)
    private let postRepository = AmityPostRepository(client: AmityUIKitManagerInternal.shared.client)
    private let mycommunityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    
    func getGlobalFeedPosts() -> AmityCollection<AmityPost> {
        feedRepository.getGlobalFeed()
    }
    
    func getCommunityFeedPosts(communityId: String) -> AmityCollection<AmityPost> {
        feedRepository.getCommunityFeed(withCommunityId: communityId, sortBy: .lastCreated, includeDeleted: false, feedType: .published)
    }
    
    func getPendingCommunityFeedPosts(communityId: String) -> AmityCollection<AmityPost> {
        feedRepository.getCommunityFeed(withCommunityId: communityId, sortBy: .lastCreated, includeDeleted: false, feedType: .reviewing)
    }
    
    func getUserFeed(userId: String) -> AmityCollection<AmityPost> {
        feedRepository.getUserFeed(userId, sortBy: .lastCreated, includeDeleted: false)
    }
    
    func getmyCommunityFeedPosts(queryOptions: AmityCommunityQueryOptions) -> AmityCollection<AmityCommunity> {
        mycommunityRepository.getCommunities(with: queryOptions)
    }

    func getPopularFeedPosts(postIDs: [String]) -> AmityCollection<AmityPost> {
        postRepository.getPosts(postIds: postIDs)
    }
}
