//
//  TestErrorViewModel.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/16.
//

import Combine
import SwiftUI

final class TestErrorViewModel: ObservableObject {
    private var useCase = TestErrorUseCase()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var isSuccess: Bool = true {
        didSet {
            TestErrorRepository.isSuccess = isSuccess
        }
    }
    @Published var value1: Int = 0
    @Published var value2: Int = 0
    @Published var value3: Int = 0
    @Published var value4: Int = 0
    @Published var isAlert: Bool = false
    var error: Error? {
        didSet {
            isAlert = error != nil
        }
    }
    
    func testArgumentPattern() {
        useCase.testArgumentPattern { value, error in
            self.value1 = value
            if let error = error {
                self.error = error as? CustomError
            }
        }
    }
    
    func testResultPattern1() {
        useCase.testResultPattern1 { result in
            switch result {
                case .success(let value):
                    self.value2 = value
                case .failure(let error):
                    self.error = error as? CustomError
            }
        }
    }
    
    func testResultPattern2() {
        useCase.testResultPattern2 { result in
            do {
                let value = try result.get()
                self.value3 = value
            } catch let error {
                self.error = error as? CustomError
            }
        }
    }
    
    func testCombinePattern() {
        useCase.testCombinePattern().sink { completion in
            switch completion {
                case .finished:
                    print("combine finish")
                case .failure(let error):
                    self.error = error as? CustomError
            }
        } receiveValue: { value in
            self.value4 = value
        }
        .store(in: &cancellables)
        
    }
}
