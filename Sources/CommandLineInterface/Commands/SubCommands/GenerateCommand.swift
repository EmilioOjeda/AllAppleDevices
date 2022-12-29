import Algorithms
import ArgumentParser
import Files
import Foundation
import ShellOut

let fileName = "Device.swift"
let validPlatformIDs = ["iphoneos", "tvos", "watchos"]

public struct GenerateCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generates the 'Device.swift' file for the given 'platforms' at the given 'path'."
    )

    public init() {}

    @Option(
        name: .shortAndLong,
        parsing: .upToNextOption,
        help: "The platform traits to produce -- i.e., '--platforms iphoneos tvos watchos'.",
        completion: .list(validPlatformIDs)
    )
    private(set) var platforms: [String] = validPlatformIDs

    @Option(
        name: .shortAndLong,
        help: "The path where the 'Device.swift' file is going to be written.",
        completion: .directory
    )
    private(set) var output: String

    public func run() throws {
        let platformIDs = platforms
            .compactMap(Platform.ID.init)
            .uniqued(on: \.id)

        guard !platformIDs.isEmpty else {
            throw GenerateCommandError.platformsOption(platforms)
        }

        guard let xcodebuildVersion = try? shellOut(to: .xcodebuildVersion) else {
            throw GenerateCommandError.executingCommand(ShellOutCommand.xcodebuildVersion.string)
        }
        guard let commandLineToolPath = try? shellOut(to: .commandLineToolPath) else {
            throw GenerateCommandError.executingCommand(ShellOutCommand.commandLineToolPath.string)
        }

        let provider = DevicesInfoProviderSQLite(
            platformIDs: platformIDs,
            xcodebuildVersion: xcodebuildVersion,
            commandLineToolPath: commandLineToolPath
        )

        guard let (xcode, platforms) = try? provider.devicesInfo() else {
            throw GenerateCommandError.readingXcodeDatabases
        }

        let fileData = fileContent(platforms: platforms, xcode: xcode).data(using: .utf8)
        guard let folder = try? Folder(path: output) else {
            throw GenerateCommandError.locatingOutputDirectory(output)
        }

        if let file = folder.files.first(where: { $0.name == fileName }) {
            guard let _ = try? file.delete() else {
                throw GenerateCommandError.deletingFile
            }
        }
        guard let _ = try? folder.createFile(named: fileName, contents: fileData) else {
            throw GenerateCommandError.creatingFile
        }
    }
}

extension ShellOutCommand {
    static let xcodebuildVersion = ShellOutCommand(string: "xcodebuild -version")
    static let commandLineToolPath = ShellOutCommand(string: "xcode-select -p")
}

enum GenerateCommandError: LocalizedError, Hashable {
    case platformsOption([String])
    case executingCommand(String)
    case readingXcodeDatabases
    case locatingOutputDirectory(String)
    case deletingFile
    case creatingFile

    var errorDescription: String? {
        switch self {
        case let .platformsOption(option):
            return """
            No matching any Platform ID.
                - given: '\(option.joined(separator: ", "))'
                - expected (at least one of or all): '\(validPlatformIDs.joined(separator: ", "))'
            """
        case let .executingCommand(command):
            return "Failed executing command: '\(command)'."
        case .readingXcodeDatabases:
            return "Failed to read Xcode's databases."
        case let .locatingOutputDirectory(directory):
            return "Failed to locate the output directory: '\(directory)'"
        case .deletingFile:
            return "Failed to delete the existing '\(fileName)' file."
        case .creatingFile:
            return "Failed to create the '\(fileName)' file."
        }
    }
}
