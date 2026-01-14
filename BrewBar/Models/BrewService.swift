//
//  BrewService.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation

struct BrewService: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    var status: ServiceStatus
    var user: String?
    var file: String?
    var exitCode: Int?

    init(id: String, name: String? = nil, status: ServiceStatus = .unknown, user: String? = nil, file: String? = nil, exitCode: Int? = nil) {
        self.id = id
        self.name = name ?? id
        self.status = status
        self.user = user
        self.file = file
        self.exitCode = exitCode
    }

    var isRunning: Bool {
        if case .running = status { return true }
        return false
    }

    var hasError: Bool {
        if case .error = status { return true }
        return false
    }
}
