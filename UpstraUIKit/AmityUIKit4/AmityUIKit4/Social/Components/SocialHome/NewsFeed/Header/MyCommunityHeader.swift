//
//  MyCommunity.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 7/11/2567 BE.
//

import SwiftUI

public struct MyCommunityHeadeComponent: AmityComponentView {
    @EnvironmentObject public var host: AmitySwiftUIHostWrapper

    public var pageId: PageId?

    public var myCommunitys: [AmityCommunityModel] = []

    public var id: ComponentId {
        .emptyNewsFeedComponent
    }

    public init(pageId: PageId? = nil, myCommunitys: [AmityCommunityModel] = []) {
        self.pageId = pageId
        self._viewConfig = StateObject(wrappedValue: AmityViewConfigController(pageId: pageId, componentId: .myCommunitiesComponent))
        self.myCommunitys = myCommunitys
        UITableView.appearance().separatorStyle = .none
    }

    @StateObject private var viewConfig: AmityViewConfigController

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("My Community")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)

                Spacer()

                Button {
                    let context = AmityMyCommunitiesHeaderComponentBehavior.Context(component: self)
                    AmityUIKitManagerInternal.shared.behavior.myCommunitiesHeaderComponentBehavior?.goToMyCommunitys(context: context)
                } label: {
                    Image(AmityIcon.getImageResource(named: "arrowIcon"))
                        .resizable()
                        .scaledToFill()
                }
                .background(Color.white)
                .frame(width: 10, height: 10)
                .padding(.horizontal, 20)

            }
            .padding(.top, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 6) {
                    ForEach(Array(myCommunitys.enumerated()), id: \.element.communityId) { index, community in
                        if index < 8 {
                            MyCommunityItem(myCommunity: community)
                                .frame(width: 70)
                                .onTapGesture {
                                    let context = AmityMyCommunitiesHeaderComponentBehavior.Context(component: self, communityId: community.communityId)
                                    AmityUIKitManagerInternal.shared.behavior.myCommunitiesHeaderComponentBehavior?.goToCommunityProfilePage(context: context)
                                }
                        } else {
                            SellAllMyCommunity()
                                .frame(width: 70)
                                .onTapGesture {
                                    let context = AmityMyCommunitiesHeaderComponentBehavior.Context(component: self)
                                    AmityUIKitManagerInternal.shared.behavior.myCommunitiesHeaderComponentBehavior?.goToMyCommunitys(context: context)
                                }

                        }

                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    MyCommunityHeadeComponent()
}
