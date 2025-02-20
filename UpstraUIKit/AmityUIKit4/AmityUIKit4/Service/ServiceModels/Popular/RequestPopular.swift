//
//  RequestPopular.swift
//  Potioneer
//
//  Created by Thavorn Kamolsin on 2/11/2567 BE.
//

import Foundation

struct RequestPopularFeedID {

    let requestMeta = BaseRequestMeta()
    var accessToken: String = ""
    let size: Int = 20

    func request(
        page: Int,
        completion: @escaping (Result<AmityTodayNewsFeedDataModel, RequestError>) -> Void
    ) {
        requestMeta.urlRequest =
            "\(DomainManager.domainAPITrueIDPopularFeed)/community/v1/popular-feeds?page=\(page)&size=\(size)"
        requestMeta.header = [
            [
                "Accept": "application/json",
                "Content": "application/json",
                "Authorization":
                    "Bearer \(AmityUIKitManagerInternal.shared.jwtAccessToken)",
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
                        AmityTodayNewsFeedDataModel.self, from: data)
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
