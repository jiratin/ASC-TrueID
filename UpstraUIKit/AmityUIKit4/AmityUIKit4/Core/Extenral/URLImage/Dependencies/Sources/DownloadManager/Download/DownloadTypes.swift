//
//  DownloadTypes.swift
//  
//
//  Created by Dmytro Anokhin on 19/07/2020.
//

import Foundation

extension DownloadManager {
    
    public enum DownloadResult {

        case data(_ data: Data)

        case file(_ path: String)
    }
}


public enum DownloadInfo {

    case progress(_ progress: Float?)

    case completion(_ result: DownloadManager.DownloadResult)
}


extension DownloadManager.DownloadResult : Hashable {}

public typealias DownloadError = Error

public typealias DownloadReceiveResponse = (_ download: Download) -> Void
public typealias DownloadReceiveData = (_ download: Download, _ data: Data) -> Void
public typealias DownloadReportProgress = (_ download: Download, _ progress: Float?) -> Void
public typealias DownloadCompletion = (_ download: Download, _ result: Result<DownloadManager.DownloadResult, DownloadError>) -> Void
