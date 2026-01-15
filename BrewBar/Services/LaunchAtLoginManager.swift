//
//  LaunchAtLoginManager.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation
import ServiceManagement
import SwiftUI

@MainActor
class LaunchAtLoginManager: ObservableObject {
    @Published var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                updateLoginItemStatus()
            }
        }
    }

    private let hasLaunchedBeforeKey = "hasLaunchedBefore"

    init() {
        // Check current status on init
        let currentStatus = SMAppService.mainApp.status == .enabled
        self.isEnabled = currentStatus

        // Auto-enable on first launch
        if !UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey) {
            UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
            if !currentStatus {
                // Auto-register on first launch
                DispatchQueue.main.async { [weak self] in
                    self?.isEnabled = true  // This triggers updateLoginItemStatus()
                }
            }
        }
    }

    private func updateLoginItemStatus() {
        do {
            if isEnabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // Revert the toggle if operation failed
            print("Failed to update login item status: \(error)")
            // Reset to actual status
            isEnabled = SMAppService.mainApp.status == .enabled
        }
    }

    /// Refresh the status from the system
    func refreshStatus() {
        isEnabled = SMAppService.mainApp.status == .enabled
    }

    /// Human-readable status for debugging
    var statusDescription: String {
        switch SMAppService.mainApp.status {
        case .notRegistered:
            return "Not registered"
        case .enabled:
            return "Enabled"
        case .requiresApproval:
            return "Requires approval in System Settings"
        case .notFound:
            return "App not found"
        @unknown default:
            return "Unknown"
        }
    }
}
