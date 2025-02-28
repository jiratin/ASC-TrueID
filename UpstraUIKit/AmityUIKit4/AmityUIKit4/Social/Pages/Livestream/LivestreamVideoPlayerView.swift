import SwiftUI
//
//  LivestreamVideoPlayerView.swift
//  AmityUIKit4
//
//  Created by Manuchet Rungraksa on 7/10/2567 BE.
//
import UIKit

struct LivestreamVideoPlayerView: View {

    @StateObject private var viewConfig: AmityViewConfigController =
        AmityViewConfigController(pageId: nil)
    @EnvironmentObject private var host: AmitySwiftUIHostWrapper
    @State private var showOverlay = false
    @State private var opacity = 0.0
    @State private var isPlaying = true
    @StateObject var networkMonitor = NetworkMonitor()
    @State var degreesRotating = 0.0

    private let debouncer = Debouncer(delay: 2)
    @StateObject var viewModel: LivestreamVideoPlayerViewModel
    @State private var isOpenLiveStreamViewer: Bool = false

    init(post: AmityPostModel) {
        self._viewModel = StateObject(
            wrappedValue: LivestreamVideoPlayerViewModel(post: post))
    }

    var body: some View {
        ZStack {

            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()

            if let stream = viewModel.stream {
                if !(stream.moderation?.terminateLabels.isEmpty ?? true) {
                    VStack(alignment: .center) {
                        Image(AmityIcon.livestreamErrorIcon.getImageResource())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                            .padding(.bottom, 12)

                        Text(
                            AmityLocalizedStringSet.Social
                                .livestreamPlayerTerminatedTitle.localizedString
                        )
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 4)

                        Text(
                            AmityLocalizedStringSet.Social
                                .livestreamPlayerTerminatedMessage
                                .localizedString
                        )
                        .multilineTextAlignment(.center)
                        .font(.system(size: 13))
                        .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 16)

                } else if stream.status == .ended {
                    VStack(alignment: .center) {
                        Text(
                            AmityLocalizedStringSet.Social
                                .livestreamPlayerEndedTitle.localizedString
                        )
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 4)

                        Text(
                            AmityLocalizedStringSet.Social
                                .livestreamPlayerEndedMessage.localizedString
                        )
                        .multilineTextAlignment(.center)
                        .font(.system(size: 13))
                        .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 16)

                    VStack {
                        HStack {
                            Spacer()
                            Image(
                                AmityIcon.livestreamCloseIcon.getImageResource()
                            )
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .onTapGesture {
                                host.controller?.dismiss(animated: true)
                            }

                        }
                        .padding(.all, 16)
                        .padding(.top, 4)

                        Spacer()
                    }
                } else {
                    VStack(alignment: .leading, spacing: 4) {

                        HStack {
                            Text(
                                AmityLocalizedStringSet.Social
                                    .livestreamPlayerLive.localizedString
                            )
                            .font(.system(size: 13, weight: .bold))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor(hex: "FF305A")))
                            .cornerRadius(4, corners: .allCorners)
                            .padding([.top, .bottom, .leading], 16)

                            HStack {
                                Image(
                                    AmityIcon.getImageResource(named: "viewEye")
                                )
                                .resizable()
                                .frame(width: 18, height: 18)
                                .clipped()

                                Text(viewModel.liveStreamViewerCount)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color.white)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(4, corners: .allCorners)
                            .onTapGesture {
                                isOpenLiveStreamViewer.toggle()
                            }

                            Spacer()
                            HStack {
                                Spacer()
                                Image(
                                    AmityIcon.livestreamCloseIcon
                                        .getImageResource()
                                )
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .onTapGesture {
                                    host.controller?.dismiss(animated: true)
                                }

                            }
                            .padding(.all, 16)
                            .padding(.top, 4)
                            .opacity(opacity)
                            .animation(
                                .easeInOut(duration: opacity == 0 ? 1.0 : 0),
                                value: opacity)

                        }

                        AmityVideoPlayerView(
                            stream: viewModel.stream,
                            isConnected: networkMonitor.isConnected,
                            isPlaying: $isPlaying
                        )
                        .padding(.bottom, 70)

                        VStack(alignment: .center) {
                           
                            HStack(alignment: .center) {
                                Spacer()
                                Image(
                                    isPlaying
                                        ? AmityIcon.livestreamPauseIcon
                                            .getImageResource()
                                        : AmityIcon.videoControlIcon
                                            .getImageResource()
                                )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    displayOverlay()
                                    isPlaying.toggle()
                                }
                                Spacer()
                            }

                            Spacer()
                        }
                        .opacity(opacity)
                        .animation(
                            .easeInOut(duration: opacity == 0 ? 1.0 : 0),
                            value: opacity)
                    }
                }
            } else if viewModel.isLoaded {
                VStack(alignment: .center) {
                    Image(AmityIcon.livestreamErrorIcon.getImageResource())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .padding(.bottom, 12)

                    Text(
                        AmityLocalizedStringSet.Social
                            .livestreamPlayerUnavailableTitle.localizedString
                    )
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 4)

                    Text(
                        AmityLocalizedStringSet.Social
                            .livestreamPlayerUnavailableMessage.localizedString
                    )
                    .multilineTextAlignment(.center)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white)
                }
                .padding(.horizontal, 16)
            }

            VStack(alignment: .center) {
                Image(AmityIcon.livestreamReconnectingIcon.getImageResource())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(degreesRotating))
                    .padding(.bottom, 12)

                Text(
                    AmityLocalizedStringSet.Social
                        .livestreamPlayerReconnectingTitle.localizedString
                )
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(Color.white)
                .padding(.bottom, 4)

                Text(
                    AmityLocalizedStringSet.Social
                        .livestreamPlayerReconnectingMessage.localizedString
                )
                .multilineTextAlignment(.center)
                .font(.system(size: 13))
                .foregroundColor(Color.white)
            }
            .padding(.horizontal, 16)
            .opacity(networkMonitor.isConnected ? 0 : 1)
            .onAppear {
                withAnimation(
                    .linear(duration: 1)
                        .speed(1).repeatForever(autoreverses: false)
                ) {
                    degreesRotating = 360.0
                }
            }

            LiveStreamViewer(
                isOpenViewer: $isOpenLiveStreamViewer,
                nameUserLiveStream: viewModel.post.postedUser?.displayName
                    ?? "", post: viewModel.post)

        }
        .onTapGesture {
            if !isOpenLiveStreamViewer {
                displayOverlay()
            }
        }

    }

    func displayOverlay() {
        opacity = 1.0

        debouncer.run {
            opacity = 0.0

        }
    }

}
