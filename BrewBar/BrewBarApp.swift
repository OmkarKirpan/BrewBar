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

@main
struct BrewBarApp: App {
    @StateObject private var serviceManager = BrewServiceManager()
    @StateObject private var toastManager = ToastManager()
    @StateObject private var pollingManager = PollingManager()
    @StateObject private var launchAtLoginManager = LaunchAtLoginManager()

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
