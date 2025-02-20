//
//  SellAllMyCommunity.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 8/11/2567 BE.
//

import SwiftUI

struct SellAllMyCommunity: View {

    @EnvironmentObject var viewConfig: AmityViewConfigController

    var body: some View {
        VStack(spacing: 4) {

            Image(AmityIcon.getImageResource(named: "nextIcon"))
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(.gray)
                .clipped()
                .clipShape(Circle())
                .padding()
                .background(Circle().fill(Color(.systemGray6)))

            HStack(alignment: .center, spacing: 4) {
                Text("See all")
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(Color(viewConfig.theme.baseColor))
                    .isHidden(viewConfig.isHidden(elementId: .communityDisplayName))
                    .accessibilityIdentifier(AccessibilityID.Social.MyCommunities.communityDisplayName)
            }
        }
        .frame(width: 70)
        .background(Color.white)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SellAllMyCommunity()
}

