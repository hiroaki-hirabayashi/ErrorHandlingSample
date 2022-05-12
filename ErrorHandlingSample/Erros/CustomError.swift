//
//  CustomError.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import Foundation

// LocalizedError: エラーの発生理由を説明する場合に使う。
// CustomNSError: 外部ライブラリなどでNSErrorが必要になった場合に使う。
/// アプリの共通エラープロトコル
public protocol CustomError: LocalizedError, CustomNSError {
    /// コンテンツ名
    static var contentName: String { get }
    /// エラー種別
    static var kindName: String { get }
}

extension CustomError {
    /// エラーコード（文字列）
    public var customErrorCode: String {
        // content + kind + code
        return Self.contentName + "-" + Self.kindName + "-" + String(format: "%04d", errorCode)
    }
}

// MARK: - CommonError

/// 共通エラープロトコル
public protocol CommonError: CustomError {
}

extension CommonError {
    static var contentName: String {
        "Common"
    }
}
