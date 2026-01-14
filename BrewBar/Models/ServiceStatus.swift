//
//  ServiceStatus.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation

enum ServiceStatus: Equatable, Hashable {
    case running
    case stopped
    case error(String)
    case unknown

    var displayName: String {
        switch self {
        case .running: return "Running"
        case .stopped: return "Stopped"
        case .error(let msg): return "Error: \(msg)"
        case .unknown: return "Unknown"
        }
    }

    var symbolName: String {
        switch self {
        case .running: return "circle.fill"
        case .stopped: return "circle"
        case .error: return "exclamationmark.circle.fill"
        case .unknown: return "questionmark.circle"
        }
    }

    var color: String {
        switch self {
        case .running: return "green"
        case .stopped: return "gray"
        case .error: return "orange"
        case .unknown: return "gray"
        }
    }
}
