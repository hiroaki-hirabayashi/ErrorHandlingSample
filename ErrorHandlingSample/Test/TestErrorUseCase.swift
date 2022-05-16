//
//  TestErrorUseCase.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/14.
//

import Combine
import Foundation

// 非同期、エラーハンドリングの方法として、以下の方法が検討できる
// * argument (T, Error?) or (T?, Error?) : エラーの時のドメインモデルを渡すならこっちもありかも
// * Result<T, Error> : callbackならResultを使う?
// * Combine: cancelを考えるとCombineもいいと思う。
// * (async/await) iOS15以降なので…
final class TestErrorUseCase {
    private var repository = TestErrorRepository()

    // ObjC時代の Pattern
    func testArgumentPattern(callback: (Int, Error?) -> Void) {
        repository.testArgumentPattern { value, error in
            if error == nil {
                // 正常処理
            } else {
                // エラー処理
            }
            callback(value, error)
        }
    }

    // Result Pattern
    func testResultPattern1(callback: (Result<Int, Error>) -> Void) {
        repository.testResultPattern { result in
            switch result {
            case .success(let value):
                callback(.success(value))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Result Pattern (do - try - catch)
    func testResultPattern2(callback: (Result<Int, Error>) -> Void) {
        repository.testResultPattern { result in
            do {
                let value = try result.get()
                callback(.success(value))
            } catch let error {
                callback(.failure(error))
            }
        }
    }

    // Combine Pattern
    func testCombinePattern() -> AnyPublisher<Int, Error> {
        repository.testCombinePattern()  // 処理が必要であればMapする？
            .mapError { error -> Error in
                // エラー処理
                print("testCombinePattern error")
                print(error)
                return error
            }
            .tryMap { value in
                // 正常処理
                print("testCombinePattern success")
                return value
            }
            .eraseToAnyPublisher()
    }
}
