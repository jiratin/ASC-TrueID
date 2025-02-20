//
//  RequestLiveStreamSaveData.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 17/11/2567 BE.
//

struct RequestLiveStreamSaveData {

    let requestMeta = BaseRequestMeta()
    var postId: String = ""
    var liveStreamId: String = ""
    var userId: String = ""
    var action: String = ""

    func request(completion: @escaping (Result<String, RequestError>) -> Void) {

        requestMeta.urlRequest = "\(DomainManager.domainAPIAmityGetLiveStream)/saveStreamViewer"
        requestMeta.header = [
            [
                "Accept": "application/json",
                "Content-Type" : "application/json",
                "Authorization":
                    "Bearer \(AmityUIKitManagerInternal.shared.currentUserToken)",
            ]
        ]
        requestMeta.method = .post
        requestMeta.endcoding = .jsonEncoding
        requestMeta.params = [
            "postId": postId,
            "liveId": liveStreamId,
            "userId": userId,
            "action": action,
        ]
        NetworkManager().request(requestMeta) { (data, response, error) in
            guard let _ = data,
                let httpResponse = response as? HTTPURLResponse, error == nil
            else {
                completion(
                    .failure(
                        RequestError(
                            errorCode: 101,
                            errorMessage: error?.localizedDescription ?? "")))
                return
            }
            switch httpResponse.statusCode {
            case 200:
                completion(.success(""))
            default:
                completion(
                    .failure(
                        RequestError(
                            errorCode: httpResponse.statusCode,
                            errorMessage: error?.localizedDescription ?? "")))
            }
        }
    }

}
