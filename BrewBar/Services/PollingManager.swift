//
//  PollingManager.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation
import Combine

@MainActor
class PollingManager: ObservableObject {
    private var timer: Timer?
    private let interval: TimeInterval = 30
    private weak var serviceManager: BrewServiceManager?

    func start(with manager: BrewServiceManager) {
        self.serviceManager = manager

        // Initial fetch
        Task {
            await manager.refresh()
        }

        // Start polling timer
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.serviceManager?.refresh()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func triggerImmediateRefresh() {
        Task {
            await serviceManager?.refresh()
        }
    }
}
