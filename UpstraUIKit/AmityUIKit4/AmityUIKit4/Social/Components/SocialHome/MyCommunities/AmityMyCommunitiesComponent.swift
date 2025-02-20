//
//  AmityMyCommunitiesComponent.swift
//  AmityUIKit4
//
//  Created by Zay Yar Htun on 5/8/24.
//

import AmitySDK
import Combine
import SwiftUI

public struct AmityMyCommunitiesComponent: AmityComponentView {
    @EnvironmentObject public var host: AmitySwiftUIHostWrapper

    public var pageId: PageId?

    public var id: ComponentId {
        .myCommunitiesComponent
    }

    @StateObject private var viewConfig: AmityViewConfigController
    @StateObject private var viewModel = AmityMyCommunitiesComponentViewModel()
    var isShowNavigationBar: Bool = false

    public init(pageId: PageId? = nil, isShowNavigationBar: Bool = false) {
        self.pageId = pageId
        self._viewConfig = StateObject(
            wrappedValue: AmityViewConfigController(
                pageId: pageId, componentId: .myCommunitiesComponent))
        self.isShowNavigationBar = isShowNavigationBar
    }

    public var body: some View {
        VStack(spacing: 0) {
            if isShowNavigationBar {
                HStack(spacing: 0) {
                    let backIcon = AmityIcon.getImageResource(named: "backIcon")
                    Image(backIcon)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(viewConfig.theme.baseColor))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 20)
                        .onTapGesture {
                            host.controller?.navigationController?
                                .popViewController(animated: true)
                        }
                        .isHidden(
                            viewConfig.isHidden(elementId: .backButtonElement))

                    Spacer()

                    Text("My Community")
                        .font(.system(size: 17, weight: .semibold))

                    Spacer()

                    Rectangle()
                        .fill(.clear)
                        .frame(width: 24, height: 24)

                }
                .padding(
                    EdgeInsets(top: 19, leading: 16, bottom: 16, trailing: 16))

            }
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.loadingStatus == .loading
                        && viewModel.communities.isEmpty
                    {
                        ForEach(0..<8, id: \.self) { _ in
                            CommunityCellSkeletonView()
                        }
                    } else {
                        ForEach(
                            Array(viewModel.communities.enumerated()),
                            id: \.element.communityId
                        ) { index, community in
                            VStack {
                                let model = AmityCommunityModel(
                                    object: community)
                                CommunityCellView(
                                    community: model, pageId: pageId,
                                    componentId: id)
                            }
                            .onTapGesture {
                                let context =
                                    AmityMyCommunitiesComponentBehavior.Context(
                                        component: self,
                                        communityId: community.communityId)
                                AmityUIKitManagerInternal.shared.behavior
                                    .myCommunitiesComponentBehavior?
                                    .goToCommunityProfilePage(context: context)
                            }
                            .onAppear {
                                if index == viewModel.communities.count - 1 {
                                    viewModel.loadMore()
                                }
                            }

                        }
                    }
                }
                .background(Color(viewConfig.theme.backgroundColor))
            }
            .updateTheme(with: viewConfig)

        }

    }

}

class AmityMyCommunitiesComponentViewModel: ObservableObject {
    @Published var communities: [AmityCommunity] = []
    @Published var loadingStatus: AmityLoadingStatus = .loading
    private let communityManager = CommunityManager()
    private let communityCollection: AmityCollection<AmityCommunity>
    private var cancellable: AnyCancellable?
    private var loadingCancellable: AnyCancellable?

    init() {
        communityCollection = communityManager.searchCommunitites(
            keyword: "", filter: .userIsMember)
        loadingCancellable = communityCollection.$loadingStatus
            .sink(receiveValue: { [weak self] status in
                self?.loadingStatus = status
            })

        cancellable = communityCollection.$snapshots
            .sink { [weak self] communities in
                self?.communities = communities
            }
    }

    func loadMore() {
        if communityCollection.hasNext {
            communityCollection.nextPage()
        }
    }
}
