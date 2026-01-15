//
//  BrewBarApp.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import SwiftUI
import Darwin

@main
struct BrewBarApp: App {
    @StateObject private var serviceManager = BrewServiceManager()
    @StateObject private var toastManager = ToastManager()
    @StateObject private var pollingManager = PollingManager()
    @StateObject private var launchAtLoginManager = LaunchAtLoginManager()

    init() {
        // Handle CLI arguments before app launches
        let args = CommandLine.arguments
        if args.contains("--version") || args.contains("-v") {
            print("BrewBar v1.1.0")
            Darwin.exit(0)
        }
        if args.contains("--help") || args.contains("-h") {
            printHelp()
            Darwin.exit(0)
        }
    }

    private func printHelp() {
        print("""
        BrewBar - Native macOS menubar app for managing Homebrew services

        Usage: BrewBar [options]

        Options:
          -v, --version    Show version information
          -h, --help       Show this help message

        When launched without options, BrewBar runs as a menubar application.

        For more information, visit: https://github.com/omkarkirpan/BrewBar
        """)
    }

    var body: some Scene {
        MenuBarExtra("BrewBar", systemImage: "mug.fill") {
            MainPanel()
                .environmentObject(serviceManager)
                .environmentObject(toastManager)
                .environmentObject(launchAtLoginManager)
                .onAppear {
                    pollingManager.start(with: serviceManager)
                }
                .onDisappear {
                    // Keep polling even when closed for future notification support
                }
        }
        .menuBarExtraStyle(.window)
    }
}
