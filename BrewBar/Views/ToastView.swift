//
//  ToastView.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI

struct ToastView: View {
    let toast: ToastManager.Toast
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(.white)

            Text(toast.message)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .lineLimit(2)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }

    private var iconName: String {
        switch toast.type {
        case .error:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .info:
            return "info.circle.fill"
        }
    }

    private var backgroundColor: Color {
        switch toast.type {
        case .error:
            return Color.red
        case .success:
            return Color.green
        case .info:
            return Color.blue
        }
    }
}
