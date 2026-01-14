//
//  BrewOutputParser.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation

struct BrewOutputParser {
    /// Parses output from `brew services list`
    /// Example format:
    /// Name          Status  User       File
    /// postgresql@14 started omkarkirpan ~/Library/LaunchAgents/homebrew.mxcl.postgresql@14.plist
    /// redis         stopped
    /// nginx         error   256 omkar  ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
    static func parseServiceList(_ output: String) -> [BrewService] {
        let lines = output.components(separatedBy: .newlines)
        var services: [BrewService] = []

        for (index, line) in lines.enumerated() {
            // Skip header line and empty lines
            if index == 0 || line.trimmingCharacters(in: .whitespaces).isEmpty {
                continue
            }

            if let service = parseLine(line) {
                services.append(service)
            }
        }

        return services.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private static func parseLine(_ line: String) -> BrewService? {
        // Split by whitespace, handling multiple spaces
        let components = line.split(whereSeparator: { $0.isWhitespace }).map(String.init)

        guard components.count >= 2 else { return nil }

        let name = components[0]
        let statusString = components[1]

        var status: ServiceStatus
        var user: String?
        var file: String?
        var exitCode: Int?

        switch statusString.lowercased() {
        case "started":
            status = .running
            // Format: Name Status User File
            if components.count >= 3 {
                user = components[2]
            }
            if components.count >= 4 {
                file = components[3]
            }

        case "stopped":
            status = .stopped
            // Stopped services might not have user/file

        case "error":
            // Format: Name error ExitCode User File
            if components.count >= 3, let code = Int(components[2]) {
                exitCode = code
                status = .error("Exit code \(code)")
                if components.count >= 4 {
                    user = components[3]
                }
                if components.count >= 5 {
                    file = components[4]
                }
            } else {
                status = .error("Unknown error")
            }

        case "none":
            status = .stopped

        default:
            status = .unknown
        }

        return BrewService(
            id: name,
            name: name,
            status: status,
            user: user,
            file: file,
            exitCode: exitCode
        )
    }
}
