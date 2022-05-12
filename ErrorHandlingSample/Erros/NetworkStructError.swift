//
//  NetworkStructError.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import Foundation

// StructはEnumとのサンプル対比のために付けているので命名には不要
/// ネットワークエラー
struct NetworkStructError: CommonError {
    /// 識別エラーコード
    var code: ErrorCode
    /// 詳細なエラー内容
    var internalError: Error?
    /// 補足内容（レスポンスの中身など）
    var detailInfo: [String: Any]?
}

// MARK: - Definition
extension NetworkStructError {
    enum ErrorCode: Int {
        // ネットワークが見つからない
        case noNetwork = 1
        // 通信処理のエラー (詳細エラーを持つ)
        case connectionFail = 2
        // タイムアウト
        case timeout = 3
        // URI/リソースが存在しない
        case notFound = 4
        // 認証失敗
        case unauthorized = 5
        // 制限つき
        case forbidden = 6
        // クライアント側のエラーの可能性
        case requestError = 7
        // サーバー側のエラー
        case serverError = 8
    }

    static func noNetwork() -> NetworkStructError {
        NetworkStructError(code: .noNetwork)
    }
    static func connectionFail(error: Error) -> NetworkStructError {
        NetworkStructError(code: .connectionFail, internalError: error)
    }
    static func timeout() -> NetworkStructError {
        NetworkStructError(code: .timeout)
    }
    static func unauthorized() -> NetworkStructError {
        NetworkStructError(code: .unauthorized)
    }
    static func forbidden(detailInfo: [String: Any]?) -> NetworkStructError {
        NetworkStructError(code: .forbidden, detailInfo: detailInfo)
    }
    static func requestError(detailInfo: [String: Any]?) -> NetworkStructError {
        NetworkStructError(code: .requestError, detailInfo: detailInfo)
    }
    static func serverError(detailInfo: [String: Any]?) -> NetworkStructError {
        NetworkStructError(code: .serverError, detailInfo: detailInfo)
    }
}

// MARK: - LocalizedError
extension NetworkStructError: LocalizedError {
    var errorDescription: String? {
        var message: String
        switch self.code {
        case .noNetwork, .connectionFail, .timeout:
            message = "通信エラー"
        case .unauthorized:
            message = "認証エラー"
        case .forbidden:
            message = "エラー"
        case .notFound, .requestError, .serverError:
            message = "エラー"
        }
        return message
    }

    var recoverySuggestion: String? {
        var message: String
        switch self.code {
        case .noNetwork, .connectionFail, .timeout:
            message = "通信エラーが発生しました。通信環境を確認の上、再度試してください。"
        case .unauthorized:
            message = ""  // 再認証が必要か
        case .forbidden:
            message = "有料会員ではないため使用できません。"
        case .notFound, .requestError, .serverError:
            message = "エラーが発生しました。時間をあけて再度試しください。"
        }

        // エラーコードを表示するのか
        // message = message + "\nエラーコード：" + self.code
        return message
    }
}

// MARK: - CustomNSError
extension NetworkStructError: CustomNSError {
    // 自動で (projectName.className)
    // public static var errorDomain: String { get }

    static var kindName: String {
        "Network"
    }

    var errorCode: Int {
        return code.rawValue
    }

    var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        if let detailInfo = detailInfo {
            userInfo["detailInfo"] = detailInfo
        }
        if let error = internalError {
            userInfo["error"] = error
        }
        return userInfo
    }
}
