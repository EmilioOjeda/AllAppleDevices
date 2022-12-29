import Foundation

public struct Xcode: Hashable {
    public let appVersion: String
    public let buildNumber: String

    init(appVersion: String, buildNumber: String) {
        self.appVersion = appVersion
        self.buildNumber = buildNumber
    }

    static let unknown = Xcode(
        appVersion: "<unknown>",
        buildNumber: "<unknown>"
    )

    public init(xcodebuildVersion: String) {
        let components = xcodebuildVersion.components(separatedBy: "\n")

        if components.count == 2 {
            let appVersionComponents = components[0].components(separatedBy: " ")
            let appVersion = appVersionComponents[appVersionComponents.endIndex.advanced(by: -1)]

            let buildNumberComponents = components[1].components(separatedBy: " ")
            let buildNumber = buildNumberComponents[buildNumberComponents.endIndex.advanced(by: -1)]

            self = Xcode(appVersion: appVersion, buildNumber: buildNumber)
        } else {
            self = .unknown
        }
    }
}
