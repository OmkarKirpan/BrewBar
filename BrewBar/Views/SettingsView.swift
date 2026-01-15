//
//  SettingsView.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var launchAtLoginManager: LaunchAtLoginManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                Button("Close", systemImage: "xmark.circle.fill") {
                    dismiss()
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Divider()

            ScrollView {
                VStack(spacing: 16) {
                    // Launch at Login toggle
                    settingsSection {
                        Toggle(isOn: $launchAtLoginManager.isEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Launch at Login")
                                    .font(.system(size: 13))

                                Text("Start BrewBar when you log in")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                    }

                    Divider()
                        .padding(.horizontal, 12)

                    // About section
                    aboutSection
                }
                .padding(.vertical, 12)
            }

            Divider()

            // Footer with version info
            HStack {
                Text("BrewBar v1.1.0")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)

                Spacer()

                Text("MIT License")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 300, height: 320)
    }

    private func settingsSection<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(.horizontal, 12)
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                // App info
                HStack(spacing: 10) {
                    Image(systemName: "mug.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("BrewBar")
                            .font(.system(size: 14, weight: .medium))

                        Text("Homebrew Services Manager")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                // Author info
                VStack(alignment: .leading, spacing: 6) {
                    Text("Created by")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)

                    Text("Omkar Kirpan")
                        .font(.system(size: 13, weight: .medium))

                    HStack(spacing: 12) {
                        Link(destination: URL(string: "https://github.com/omkarkirpan")!) {
                            Label("GitHub", systemImage: "link")
                                .font(.system(size: 11))
                        }

                        Link(destination: URL(string: "https://www.omkarkirpan.com")!) {
                            Label("Website", systemImage: "globe")
                                .font(.system(size: 11))
                        }
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(.horizontal, 12)
    }
}
