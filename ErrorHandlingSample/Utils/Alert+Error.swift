//
//  Alert+Error.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import SwiftUI

extension Alert {
    init(_ error: Error) {
        self = Alert(error as NSError)
    }

    init(_ nsError: NSError) {
        var message: Text? = nil
        if let str = nsError.localizedRecoverySuggestion {
            message = Text(str)
        }
        self = Alert(
            title: Text(nsError.localizedDescription),
            message: message,
            dismissButton: .default(Text("OK"))
        )
    }
}
