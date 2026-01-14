//
//  ServiceListView.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI

struct ServiceListView: View {
    let services: [BrewService]
    let onStart: (BrewService) -> Void
    let onStop: (BrewService) -> Void
    let onRestart: (BrewService) -> Void

    var body: some View {
        if services.isEmpty {
            emptyState
        } else {
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(services) { service in
                        ServiceRowView(
                            service: service,
                            onStart: { onStart(service) },
                            onStop: { onStop(service) },
                            onRestart: { onRestart(service) }
                        )
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 24))
                .foregroundColor(.secondary)

            Text("No services found")
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            Text("Install services with Homebrew to see them here")
                .font(.system(size: 11))
                .foregroundColor(.secondary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
    }
}
