//
//  SimpleError.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import Foundation

/// 簡易エラー
///
/// 特に内容を伝播する必要のないエラー。
/// エラーになったことが分かれば良い。エラー表示は汎用的で良い。
enum SimpleError: CommonError {
    /// エラー
    case failure(internalError: Error?)
}

// MARK: - LocalizedError
extension SimpleError: LocalizedError {
    var errorDescription: String? {
        var message: String
        switch self {
        case .failure:
            message = "エラー"
        }
        return message
    }

    var recoverySuggestion: String? {
        var message: String
        switch self {
        case .failure:
            message = "エラーが発生しました。時間をあけて再度試しください。"
        }

        // エラーコードを表示するのか
        // message = message + "\nエラーコード：" + self.code
        return message
    }
}

// MARK: - CustomNSError
extension SimpleError: CustomNSError {
    static var kindName: String {
        "S"
    }

    var errorCode: Int {
        switch self {
        case .failure:
            return 1
        }
    }

    var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        switch self {
        case .failure(let error):
            userInfo["error"] = error
        }
        return userInfo
    }
}
