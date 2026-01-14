//
//  HeaderView.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI

struct HeaderView: View {
    let isLoading: Bool
    let onRefresh: () -> Void
    let onStartAll: () -> Void
    let onStopAll: () -> Void

    var body: some View {
        HStack {
            Text("BrewBar")
                .font(.system(size: 14, weight: .semibold))

            Spacer()

            HStack(spacing: 8) {
                // Refresh button
                Button(action: onRefresh) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12))
                        .rotationEffect(.degrees(isLoading ? 360 : 0))
                        .animation(isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isLoading)
                }
                .buttonStyle(.plain)
                .disabled(isLoading)
                .help("Refresh services")

                Divider()
                    .frame(height: 16)

                // Start all
                Button(action: onStartAll) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                }
                .buttonStyle(.plain)
                .help("Start all services")

                // Stop all
                Button(action: onStopAll) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 10))
                }
                .buttonStyle(.plain)
                .help("Stop all services")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
