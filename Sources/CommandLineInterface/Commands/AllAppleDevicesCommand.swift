import ArgumentParser

public struct AllAppleDevicesCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "all-apple-devices",
        abstract: "Provides the information of all the devices available in the selected command-line tool database.",
        subcommands: [GenerateCommand.self]
    )

    public init() {}
}
