//
//  TestErrorView.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import SwiftUI

struct TestErrorView: View {
    @ObservedObject var viewModel = TestErrorViewModel()
    
    var body: some View {
        List {
            Toggle("success", isOn: $viewModel.isSuccess)
            Button {
                viewModel.testArgumentPattern()
            } label: {
                Text("Test argument value=\(viewModel.value1)")
            }
            
            Button {
                viewModel.testResultPattern1()
            } label: {
                Text("Test Result1 value=\(viewModel.value2)")
            }
            
            Button {
                viewModel.testResultPattern2()
            } label: {
                Text("Test Result2 value=\(viewModel.value3)")
            }
            
            Button {
                viewModel.testCombinePattern()
            } label: {
                Text("Test Combine value=\(viewModel.value3)")
            }
        }
        .alert(
            isPresented: $viewModel.isAlert,
            content: {
                // presentation側で文言を決める場合は別途、変換用のfunctionを作成するなど
                Alert(viewModel.error!)
            }
        )
    }
}

struct TestErrorView_Previews: PreviewProvider {
    static var previews: some View {
        TestErrorView()
    }
}
