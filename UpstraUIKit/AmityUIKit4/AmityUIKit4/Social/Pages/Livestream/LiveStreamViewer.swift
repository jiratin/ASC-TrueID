//
//  LiveStreamViewer.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 18/11/2567 BE.
//

import AmitySDK
import Combine
import SwiftUI

struct LiveStreamViewer: View {
    @Binding var isOpenViewer: Bool
    @State var nameUserLiveStream: String
    @StateObject var viewModel: LiveStreamViewerViewModel

    init(isOpenViewer: Binding<Bool>, nameUserLiveStream: String, post: AmityPostModel) {
        self._isOpenViewer = isOpenViewer
        self.nameUserLiveStream = nameUserLiveStream
        self._viewModel = StateObject(wrappedValue: LiveStreamViewerViewModel(post: post))
    }

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.3))
            .opacity(isOpenViewer ? 1 : 0)
            .animation(.easeIn)
            .onTapGesture {
                isOpenViewer.toggle()
            }

            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(nameUserLiveStream)'s live video")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Button {
                        isOpenViewer.toggle()
                    } label: {
                        Image(AmityIcon.getImageResource(named: "grayCloseIcon"))
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipped()
                    }
                }

                Divider()
                    .background(Color.white)

                Text("Who's watching")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 10)

                List {
                    ForEach(Array(viewModel.viewerUserList.enumerated()), id: \.element.userId) { index, item in
                        HStack(spacing: 10) {
                            AmityUserProfileImageView(displayName: item.displayName, avatarURL: URL(string: item.avatarURL))
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            Text(item.displayName)
                                .foregroundColor(.black)
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.top, 10)
                        .listRowInsets(EdgeInsets())
                        .modifier(HiddenListSeparator())
                        .onAppear {
                            if (viewModel.viewerUserList.count > 0) && (viewModel.page < viewModel.maxPage) && (index == viewModel.viewerUserList.count - 2) {
                                viewModel.page += 1
                                viewModel.getLiveStreamData()
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 1.5)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 1)
            .offset(y: isOpenViewer ? (UIScreen.main.bounds.height / 6.5) : (UIScreen.main.bounds.height / 2) * 3)
            .animation(.default.delay(0.1))
        }
        .ignoresSafeArea()
    }
}

class LiveStreamViewerViewModel: ObservableObject {
    var page: Int = 1
    var maxPage: Int = 1
    var post: AmityPostModel
    var viewerIDListID: [AmityUserModel] = []
    @Published var viewerUserList: [AmityUserModel] = []
    var tokenUser: AmityNotificationToken?
    private let userManager = UserManager()
    var isLoading: Bool = false

    init(post: AmityPostModel) {
        self.post = post
        getLiveStreamData()
    }

    func getLiveStreamData() {
        if isLoading {
            return
        }
        var serviceRequest = RequestLiveStreamViewerCount()
        serviceRequest.pageNumber = page
        serviceRequest.liveStreamId = post.liveStream?.streamId ?? ""
        serviceRequest.type = "watching"
        serviceRequest.request { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.getAllUserByID(listID: response.viewer)
                    self.maxPage = response.maxPage
                }
            case .failure(let err):
                debugPrint(err.errorMessage)
            }
        }
    }

    func getAllUserByID(listID: [String]) {
        viewerIDListID = []
        let dispatchGroup = DispatchGroup()
        for (_, value) in listID.enumerated() {
            dispatchGroup.enter()
            getUserProfileByID(userID: value) { [weak self] userModel in
                guard let self else { return }
                self.viewerIDListID.append(userModel)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.viewerUserList = self.viewerUserList + self.viewerIDListID
            self.isLoading = false
        }
    }

    func getUserProfileByID(userID: String, completion: @escaping (AmityUserModel) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tokenUser = self.userManager.getUser(withId: userID).observeOnce({ user, error in
                guard let userObject = user.snapshot else { return }
                completion(AmityUserModel(user: userObject))
            })
        }
    }
}
