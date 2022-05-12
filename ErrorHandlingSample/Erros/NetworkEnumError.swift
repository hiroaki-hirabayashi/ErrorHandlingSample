//
//  NetworkEnumError.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import Foundation

// EnumはStructとのサンプル対比のために付けているので命名には不要
/// ネットワークエラー
enum NetworkEnumError: CommonError {
    // ネットワークが見つからない
    case noNetwork
    // タイムアウト
    case timeout
    // 通信処理のエラー (詳細エラーを持つ)
    case connectionFail(error: Error?)
    // URI/リソースが存在しない
    case notFound
    // 認証失敗
    case unauthorized
    // 制限つき
    case forbidden(response: [String: Any]?)
    // クライアント側のエラーの可能性
    case requestError(response: [String: Any]?)
    // サーバー側のエラー
    case serverError(response: [String: Any]?)
}

// MARK: - LocalizedError
extension NetworkEnumError: LocalizedError {
    var errorDescription: String? {
        var message: String
        switch self {
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
        switch self {
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
extension NetworkEnumError: CustomNSError {
    // 自動で (projectName.className)
    // public static var errorDomain: String { get }

    static var kindName: String {
        "Network"
    }

    // 自動採番になると、argumentあり→なしの順番になる
    var errorCode: Int {
        // 引数ありにすると数値定義できない。一意採番を意識すると二重管理になる？
        enum ErrorCode: Int {
            case noNetwork = 1
            case timeout = 2
            case connectionFail = 3
            case notFound = 4
            case unauthorized = 5
            case forbidden = 6
            case requestError = 7
            case serverError = 8
        }

        let code: ErrorCode
        switch self {
        case .noNetwork:
            code = .noNetwork
        case .connectionFail:
            code = .connectionFail
        case .timeout:
            code = .timeout
        case .notFound:
            code = .notFound
        case .unauthorized:
            code = .unauthorized
        case .forbidden:
            code = .forbidden
        case .requestError:
            code = .requestError
        case .serverError:
            code = .serverError
        }
        return code.rawValue
    }

    var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        switch self {
        case .forbidden(let response),
            .requestError(let response),
            .serverError(let response):
            userInfo["response"] = response
        case .connectionFail(let error):
            userInfo["error"] = error
        default:
            break
        }
        return userInfo
    }
}
