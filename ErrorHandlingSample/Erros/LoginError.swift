//
//  LoginError.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/16.
//

import Foundation

enum LoginError: Int, CommonError {
    /// ログイン失敗
    case loginFailure = 1
}

// MARK: - LocalizedError
extension LoginError: LocalizedError {
    var errorDescription: String? {
        var message: String
        switch self {
        case .loginFailure:
            message = "認証エラー"
        }
        return message
    }

    var recoverySuggestion: String? {
        var message: String
        switch self {
        case .loginFailure:
            message = "入力内容が間違っている可能性があります。"
        }

        // エラーコードを表示するのか
        // message = message + "\nエラーコード：" + self.code
        return message
    }
}

// MARK: - CustomNSError
extension LoginError: CustomNSError {
    static var kindName: String {
        "Login"
    }

    var errorCode: Int {
        return self.rawValue
    }
}
