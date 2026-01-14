//
//  MainPanel.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI

struct MainPanel: View {
    @EnvironmentObject var serviceManager: BrewServiceManager
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var launchAtLoginManager: LaunchAtLoginManager
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(
                isLoading: serviceManager.isLoading,
                onRefresh: {
                    Task { await serviceManager.refresh() }
                },
                onStartAll: {
                    Task { await serviceManager.startAll() }
                },
                onStopAll: {
                    Task { await serviceManager.stopAll() }
                }
            )

            Divider()

            // Service list
            ServiceListView(
                services: serviceManager.services,
                onStart: { service in
                    Task {
                        let success = await serviceManager.start(service)
                        if success {
                            toastManager.showSuccess("Started \(service.name)")
                        } else if let error = serviceManager.lastError {
                            toastManager.showError(error)
                        }
                    }
                },
                onStop: { service in
                    Task {
                        let success = await serviceManager.stop(service)
                        if success {
                            toastManager.showSuccess("Stopped \(service.name)")
                        } else if let error = serviceManager.lastError {
                            toastManager.showError(error)
                        }
                    }
                },
                onRestart: { service in
                    Task {
                        let success = await serviceManager.restart(service)
                        if success {
                            toastManager.showSuccess("Restarted \(service.name)")
                        } else if let error = serviceManager.lastError {
                            toastManager.showError(error)
                        }
                    }
                }
            )
            .frame(minHeight: 100, maxHeight: 300)

            Divider()

            // Footer
            FooterView(showingSettings: $showingSettings)
        }
        .frame(width: 300)
        .overlay(alignment: .top) {
            if let toast = toastManager.currentToast {
                ToastView(toast: toast, onDismiss: { toastManager.dismiss() })
                    .padding(.horizontal, 8)
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(launchAtLoginManager)
        }
        .task {
            await serviceManager.refresh()
        }
    }
}

struct FooterView: View {
    @Binding var showingSettings: Bool

    var body: some View {
        HStack {
            Button("Settings", systemImage: "gear") {
                showingSettings = true
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            .help("Settings")

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.borderless)
            .font(.system(size: 11))
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
