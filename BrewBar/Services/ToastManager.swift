//
//  ToastManager.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation
import SwiftUI

@MainActor
class ToastManager: ObservableObject {
    @Published var currentToast: Toast?

    struct Toast: Identifiable, Equatable {
        let id = UUID()
        let message: String
        let type: ToastType

        enum ToastType {
            case error
            case success
            case info
        }

        static func == (lhs: Toast, rhs: Toast) -> Bool {
            lhs.id == rhs.id
        }
    }

    func show(_ message: String, type: Toast.ToastType = .error) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentToast = Toast(message: message, type: type)
        }

        // Auto-dismiss after 3 seconds
        let toastId = currentToast?.id
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if currentToast?.id == toastId {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentToast = nil
                }
            }
        }
    }

    func dismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentToast = nil
        }
    }

    func showError(_ message: String) {
        show(message, type: .error)
    }

    func showSuccess(_ message: String) {
        show(message, type: .success)
    }
}
