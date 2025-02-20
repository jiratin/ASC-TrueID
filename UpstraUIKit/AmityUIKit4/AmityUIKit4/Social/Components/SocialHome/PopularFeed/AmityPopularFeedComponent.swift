//
//  PopularFeed.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 31/10/2567 BE.
//

import SwiftUI
import AmitySDK
import Combine

public struct AmityPopularFeedComponent: AmityComponentView {
    
    @EnvironmentObject public var host: AmitySwiftUIHostWrapper
    
    public var pageId: PageId?
    
    public var id: ComponentId {
        .emptyNewsFeedComponent
    }
    
    @StateObject private var viewConfig: AmityViewConfigController
    @StateObject private var postFeedViewModel = PostFeedViewModel(feedType: .popularFeed)
    @StateObject private var viewModel = AmityNewsFeedComponentViewModel()
    @State private var pullToRefreshShowing: Bool = false
    
    public init(pageId: PageId? = nil) {
        self.pageId = pageId
        self._viewConfig = StateObject(wrappedValue: AmityViewConfigController(pageId: pageId, componentId: .emptyNewsFeedComponent))
        UITableView.appearance().separatorStyle = .none
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            getContentView()
                .opacity(postFeedViewModel.postItems.isEmpty && postFeedViewModel.feedLoadingStatus == .loaded ? 0 : 1)
            
            AmityEmptyNewsFeedComponent(pageId: pageId)
                .opacity(postFeedViewModel.postItems.isEmpty && postFeedViewModel.feedLoadingStatus == .loaded ? 1 : 0)
        }
        .updateTheme(with: viewConfig)
    }
    
    @ViewBuilder
    func getContentView() -> some View {
        if #available(iOS 15.0, *) {
            getPostListView()
            .refreshable {
                // just to show/hide story view
                viewModel.loadStoryTargets()
                // refresh global feed
                // swiftUI cannot update properly if we use nested Observable Object
                // that is the reason why postFeedViewModel is not moved into viewModel
                postFeedViewModel.isLoadingNextPage = true
                postFeedViewModel.page = 1
                postFeedViewModel.loadFeed(feedType: .popularFeed)
            }
        } else {
            getPostListView()
        }
    }
    
    @ViewBuilder
    func getPostListView() -> some View {
        List {
            if postFeedViewModel.postItems.isEmpty {
                ForEach(0..<5, id: \.self) { index in
                    VStack(spacing: 0) {
                        PostContentSkeletonView()
                    }
                    .listRowInsets(EdgeInsets())
                    .modifier(HiddenListSeparator())
                }
            } else {
                ForEach(Array(postFeedViewModel.postItems.enumerated()), id: \.element.id) { index, item in
                    VStack(spacing: 0) {
                        
                        switch item.type {
                        case .ad(let ad):
                            VStack(spacing: 0) {
                                AmityFeedAdContentComponent(ad: ad)

                                Rectangle()
                                    .fill(Color(viewConfig.theme.baseColorShade4))
                                    .frame(height: 8)
                            }
                            
                        case .content(let post):
                            
                            VStack(spacing: 0){
                                AmityPostContentComponent(post: post.object, category: post.isPinned ? .global : .general, onTapAction: {_ in 
                                    let context = AmityPopularFeedComponentBehavior.Context(component: self, post: post)
                                    AmityUIKitManagerInternal.shared.behavior.popularFeedComponentBehavior?.goToPostDetailPage(context: context)
                                }, pageId: pageId)
                                .contentShape(Rectangle())
                                .background(GeometryReader { geometry in
                                    Color.clear
                                        .onChange(of: geometry.frame(in: .global)) { frame in
                                            checkVisibilityAndMarkSeen(postContentFrame: frame, post: post)
                                        }
                                })
                                
                                Rectangle()
                                    .fill(Color(viewConfig.theme.baseColorShade4))
                                    .frame(height: 8)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .modifier(HiddenListSeparator())
                    .onAppear {
                        if index == postFeedViewModel.postItems.count - 1 {
                            postFeedViewModel.loadMorePopularPosts()
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func checkVisibilityAndMarkSeen(postContentFrame: CGRect, post: AmityPostModel) {
        let screenHeight = UIScreen.main.bounds.height
        let visibleHeight = min(screenHeight, postContentFrame.maxY) - max(0, postContentFrame.minY)
        let visiblePercentage = (visibleHeight / postContentFrame.height) * 100
        if visiblePercentage > 60 && !postFeedViewModel.seenPostIds.contains(post.postId) {
            postFeedViewModel.seenPostIds.insert(post.postId)
            post.analytic.markAsViewed()
        }
    }
}


#Preview {
    AmityPopularFeedComponent()
}
