//
//  ServiceRowView.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI

struct ServiceRowView: View {
    let service: BrewService
    let onStart: () -> Void
    let onStop: () -> Void
    let onRestart: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 8) {
            // Status indicator
            Image(systemName: service.status.symbolName)
                .foregroundColor(statusColor)
                .font(.system(size: 10))
                .frame(width: 14)

            // Service name
            Text(service.name)
                .font(.system(size: 13))
                .lineLimit(1)
                .truncationMode(.middle)

            Spacer()

            // Action buttons (show on hover or always on touch)
            HStack(spacing: 4) {
                ActionButton(
                    systemImage: "play.fill",
                    action: onStart,
                    disabled: service.isRunning
                )

                ActionButton(
                    systemImage: "stop.fill",
                    action: onStop,
                    disabled: !service.isRunning
                )

                ActionButton(
                    systemImage: "arrow.clockwise",
                    action: onRestart,
                    disabled: false
                )
            }
            .opacity(isHovering ? 1 : 0.5)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(isHovering ? Color.gray.opacity(0.1) : Color.clear)
        .cornerRadius(6)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .help(tooltipText)
    }

    private var statusColor: Color {
        switch service.status {
        case .running:
            return .green
        case .stopped:
            return .gray
        case .error:
            return .orange
        case .unknown:
            return .gray
        }
    }

    private var tooltipText: String {
        var text = "\(service.name): \(service.status.displayName)"
        if let user = service.user {
            text += "\nUser: \(user)"
        }
        if let exitCode = service.exitCode {
            text += "\nExit code: \(exitCode)"
        }
        return text
    }
}

struct ActionButton: View {
    let systemImage: String
    let action: () -> Void
    let disabled: Bool

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 10))
                .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
    }
}
