//
//  MyCommunityItem.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 8/11/2567 BE.
//

import SwiftUI

struct MyCommunityItem: View {
    
    @EnvironmentObject var viewConfig: AmityViewConfigController
    
    @State var myCommunity: AmityCommunityModel?
    
    var body: some View {
        VStack(spacing: 4) {
            AsyncImage(placeholder: AmityIcon.communityThumbnail.imageResource, url: URL(string: myCommunity?.avatarURL ?? ""))
                .frame(size: CGSize(width: 50, height: 50))
                .clipped()
                .clipShape(Circle())
                .isHidden(viewConfig.isHidden(elementId: .communityAvatar))
                .accessibilityIdentifier(AccessibilityID.Social.MyCommunities.communityAvatar)
            
            HStack(alignment: .center, spacing: 4) {
                Text(myCommunity?.displayName ?? "")
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(Color(viewConfig.theme.baseColor))
                    .isHidden(viewConfig.isHidden(elementId: .communityDisplayName))
                    .accessibilityIdentifier(AccessibilityID.Social.MyCommunities.communityDisplayName)
                
                if myCommunity?.isOfficial ?? false {
                    let verifiedBadgeIcon = AmityIcon.getImageResource(named: "verifiedBadge")
                    Image(verifiedBadgeIcon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 16, height: 16)
                        .offset(y: -1)
                        .isHidden(viewConfig.isHidden(elementId: .communityOfficialBadge))
                        .accessibilityIdentifier(AccessibilityID.Social.MyCommunities.communityOfficialBadge)
                        .layoutPriority(1)
                }
            }
        }
        .frame(width: 70)
        .background(Color.white)
        .padding(.horizontal, 20)
    }
}

#Preview {
    MyCommunityItem(myCommunity: nil)
}
