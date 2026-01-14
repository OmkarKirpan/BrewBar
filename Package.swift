// swift-tools-version:5.9
//
//  Package.swift
//  BrewBar
//
//  Created by Omkar Kirpan on 13/01/26.
//  Author: Omkar Kirpan
//  GitHub: https://github.com/omkarkirpan
//  Website: https://www.omkarkirpan.com
//

import PackageDescription

let package = Package(
    name: "BrewBar",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "BrewBar",
            path: "BrewBar"
        )
    ]
)
