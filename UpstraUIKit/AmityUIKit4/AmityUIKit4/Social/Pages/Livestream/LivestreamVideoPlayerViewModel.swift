//
//  LivestreamVideoPlayerViewModel.swift
//  AmityUIKit4
//
//  Created by Manuchet Rungraksa on 7/10/2567 BE.
//

import AmitySDK

class LivestreamVideoPlayerViewModel: ObservableObject {
    
    var streamRepository = AmityStreamRepository(client: AmityUIKit4Manager.client)
    
    var token: AmityNotificationToken?
    let post: AmityPostModel
    let page: Int = 1
    @Published var isLoaded = false
    @Published var liveStreamViewerCount: String = ""
    @Published var stream: AmityStream?
    
    init(post: AmityPostModel) {
        self.post = post
        observeStream(streamId: post.liveStream?.streamId ?? "")
        self.liveStreamViewerCount = 0.formattedCountString
        realtimeUpdateStream()
    }
    
    private func observeStream(streamId: String) {
        token?.invalidate()
        token = nil
        isLoaded = false
        
        token = streamRepository.getStream(streamId).observe { [weak self] data, error in
            self?.isLoaded = true
            if let stream = data.snapshot {                
                
                if stream.status != .idle {
                    self?.stream = stream
                }
                
                if stream.status == .ended {
                    NotificationCenter.default.post(name: .didLivestreamStatusUpdated, object: self?.post.object)
                }
                
            } else {
                print("Stream is not available or ended.")
            }
        }
    }
    
    private func realtimeUpdateStream() {
        saveLiveStreamData()
        getLiveStreamData()
    }
    
    private func reloadCallGetCount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            self.getLiveStreamData()
        }
    }

    func saveLiveStreamData() {
        var serviceRequest = RequestLiveStreamSaveData()
        serviceRequest.postId = post.postId
        serviceRequest.liveStreamId = post.liveStream?.streamId ?? ""
        serviceRequest.userId = AmityUIKitManagerInternal.shared.currentUserId
        serviceRequest.action = "join"
        serviceRequest.request { _ in }
    }

    private func getLiveStreamData() {
        var serviceRequest = RequestLiveStreamViewerCount()
        serviceRequest.pageNumber = page
        serviceRequest.liveStreamId = post.liveStream?.streamId ?? ""
        serviceRequest.type = "watching"
        serviceRequest.request { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.liveStreamViewerCount = response.count.formattedCountString
                }
                self.reloadCallGetCount()
            case .failure(let err):
                debugPrint(err.errorMessage)
                self.reloadCallGetCount()
            }
        }
    }
}
