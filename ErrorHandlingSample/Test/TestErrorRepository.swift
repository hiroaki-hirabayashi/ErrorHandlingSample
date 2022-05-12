//
//  TestErrorRepository.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import Alamofire
import Combine
import Foundation

class TestErrorRepository {
    static var isSuccess: Bool = true
    var test: Int = 0

    func testArgumentPattern(callback: (Int, Error?) -> Void) {
        testPrintError()

        if Self.isSuccess {
            test = test + 1
            callback(test, nil)
        } else {
            callback(0, NetworkStructError.noNetwork())
        }
    }

    func testResultPattern(callback: (Result<Int, Error>) -> Void) {
        testPrintError()

        if Self.isSuccess {
            test = test + 1
            callback(.success(test))
        } else {
            callback(.failure(NetworkEnumError.noNetwork))
        }
    }

    func testCombinePattern() -> AnyPublisher<Int, Error> {
        Future { promise in
            if Self.isSuccess {
                self.test = self.test + 1
                promise(.success(1))
            } else {
                promise(.failure(NetworkStructError.noNetwork()))
            }
        }.eraseToAnyPublisher()
    }

    func testPrintError() {
        let test0 = NetworkEnumError.noNetwork
        let test1 = NetworkEnumError.requestError(response: ["test1": "test"])
        let test2 = NetworkEnumError.serverError(response: ["test2": "test"])
        printError(test0)
        printError(test1)
        printError(test2)

        let test3 = NetworkStructError.connectionFail(error: AFError.sessionDeinitialized)
        let test4 = NetworkStructError.requestError(detailInfo: ["test1": "test"])
        let test5 = NetworkStructError.serverError(detailInfo: ["test2": "test"])
        printError(test3)
        printError(test4)
        printError(test5)

        let test6 = SimpleError.failure(internalError: TestRepositoryError.parseError)
        printError(test6)
    }

    func printError(_ error: CustomError) {
        print("----------------- error print test -----------------")
        print(error)
        print(error.localizedDescription)
        print(error.customErrorCode)
        print((error as NSError).domain)
        print((error as NSError).code)
        print((error as NSError).userInfo)
    }
}

enum TestRepositoryError: Error {
    case parseError
}
