//
//  ShellExecutor.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import Foundation

actor ShellExecutor {
    struct CommandResult {
        let output: String
        let error: String
        let exitCode: Int32

        var succeeded: Bool { exitCode == 0 }
    }

    enum ShellError: Error, LocalizedError {
        case brewNotFound
        case executionFailed(String)

        var errorDescription: String? {
            switch self {
            case .brewNotFound:
                return "Homebrew not found. Please install Homebrew first."
            case .executionFailed(let message):
                return "Command failed: \(message)"
            }
        }
    }

    private let brewPath: String

    init() {
        // Check Apple Silicon path first, then Intel
        if FileManager.default.fileExists(atPath: "/opt/homebrew/bin/brew") {
            self.brewPath = "/opt/homebrew/bin/brew"
        } else if FileManager.default.fileExists(atPath: "/usr/local/bin/brew") {
            self.brewPath = "/usr/local/bin/brew"
        } else {
            self.brewPath = "/opt/homebrew/bin/brew" // Default, will fail gracefully
        }
    }

    func run(arguments: [String]) async throws -> CommandResult {
        guard FileManager.default.fileExists(atPath: brewPath) else {
            throw ShellError.brewNotFound
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: brewPath)
        process.arguments = arguments

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            throw ShellError.executionFailed(error.localizedDescription)
        }

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        let output = String(data: outputData, encoding: .utf8) ?? ""
        let errorOutput = String(data: errorData, encoding: .utf8) ?? ""

        return CommandResult(
            output: output,
            error: errorOutput,
            exitCode: process.terminationStatus
        )
    }

    func listServices() async throws -> CommandResult {
        try await run(arguments: ["services", "list"])
    }

    func startService(_ name: String) async throws -> CommandResult {
        try await run(arguments: ["services", "start", name])
    }

    func stopService(_ name: String) async throws -> CommandResult {
        try await run(arguments: ["services", "stop", name])
    }

    func restartService(_ name: String) async throws -> CommandResult {
        try await run(arguments: ["services", "restart", name])
    }
}
