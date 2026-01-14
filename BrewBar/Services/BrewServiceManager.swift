//
//  BrewServiceManager.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation
import SwiftUI

@MainActor
class BrewServiceManager: ObservableObject {
    @Published var services: [BrewService] = []
    @Published var isLoading: Bool = false
    @Published var lastError: String?

    private let shell = ShellExecutor()

    func refresh() async {
        isLoading = true
        lastError = nil

        do {
            let result = try await shell.listServices()
            if result.succeeded {
                services = BrewOutputParser.parseServiceList(result.output)
            } else {
                lastError = result.error.isEmpty ? "Failed to list services" : result.error
            }
        } catch {
            lastError = error.localizedDescription
        }

        isLoading = false
    }

    func start(_ service: BrewService) async -> Bool {
        do {
            let result = try await shell.startService(service.id)
            await refresh()
            if !result.succeeded {
                lastError = "Failed to start \(service.name): \(result.error)"
                return false
            }
            return true
        } catch {
            lastError = error.localizedDescription
            return false
        }
    }

    func stop(_ service: BrewService) async -> Bool {
        do {
            let result = try await shell.stopService(service.id)
            await refresh()
            if !result.succeeded {
                lastError = "Failed to stop \(service.name): \(result.error)"
                return false
            }
            return true
        } catch {
            lastError = error.localizedDescription
            return false
        }
    }

    func restart(_ service: BrewService) async -> Bool {
        do {
            let result = try await shell.restartService(service.id)
            await refresh()
            if !result.succeeded {
                lastError = "Failed to restart \(service.name): \(result.error)"
                return false
            }
            return true
        } catch {
            lastError = error.localizedDescription
            return false
        }
    }

    func startAll() async {
        for service in services where !service.isRunning {
            _ = await start(service)
        }
    }

    func stopAll() async {
        for service in services where service.isRunning {
            _ = await stop(service)
        }
    }
}
