//
//  RequestLiveStreamViewerCount.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 17/11/2567 BE.
//

struct RequestLiveStreamViewerCount {

    let requestMeta = BaseRequestMeta()
    var pageNumber: Int = 0
    var liveStreamId: String = ""
    var type: String = ""

    func request(completion: @escaping (Result<StreamViewerDataModel, RequestError>) -> Void) {

        requestMeta.urlRequest = "\(DomainManager.domainAPIAmityGetLiveStream)/getStreamViewer?liveStreamId=\(liveStreamId)&page=\(pageNumber)&type=\(type)"
        requestMeta.header = [
            [
                "Accept": "application/json",
                "Content": "application/json",
                "Authorization":
                    "Bearer \(AmityUIKitManagerInternal.shared.currentUserToken)",
            ]
        ]
        requestMeta.method = .get
        requestMeta.endcoding = .urlEncoding
        NetworkManager().request(requestMeta) { (data, response, error) in
            guard let data = data,
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
                guard
                    let dataModel = try? JSONDecoder().decode(
                        StreamViewerDataModel.self, from: data)
                else {
                    completion(
                        .failure(
                            RequestError(
                                errorCode: 101,
                                errorMessage: "Json can't decode")))
                    return
                }
                completion(.success(dataModel))
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
