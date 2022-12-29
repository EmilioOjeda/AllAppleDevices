@testable import CommandLineInterface
import XCTest

final class CodeGenerationTests: XCTestCase {
    func testCodeGeneration() throws {
        let (xcode, platforms) = try FakeDevicesInfoProvider()
            .devicesInfo()

        XCTAssertEqual(
            fileContentSnapshot,
            fileContent(platforms: platforms, xcode: xcode)
        )
    }

    func testFunctions() {
        typealias Given = (id: String, name: String)
        typealias Then = (sanitized: String, caseItem: String, propertyItem: String)
        typealias Spec = (given: Given, then: Then)

        let specs: [Spec] = [
            (
                given: (id: "MacFamily20,1", name: "Mac"),
                then: (
                    sanitized: "macFamily20_1",
                    caseItem: ".macFamily20_1",
                    propertyItem: #"""
                    /// Mac
                        public static let macFamily20_1 = Device(id: "MacFamily20,1", model: "Mac")
                    """#
                )
            ),
            (
                given: (id: "iPod9,1", name: "iPod touch (7th generation)"),
                then: (
                    sanitized: "iPod9_1",
                    caseItem: ".iPod9_1",
                    propertyItem: #"""
                    /// iPod touch (7th generation)
                        public static let iPod9_1 = Device(id: "iPod9,1", model: "iPod touch (7th generation)")
                    """#
                )
            ),
            (
                given: (id: "iPad11,7", name: "iPad (8th generation)"),
                then: (
                    sanitized: "iPad11_7",
                    caseItem: ".iPad11_7",
                    propertyItem: #"""
                    /// iPad (8th generation)
                        public static let iPad11_7 = Device(id: "iPad11,7", model: "iPad (8th generation)")
                    """#
                )
            ),
            (
                given: (id: "iPad14,6-B", name: "iPad Pro (12.9-inch) (6th generation)"),
                then: (
                    sanitized: "iPad14_6_B",
                    caseItem: ".iPad14_6_B",
                    propertyItem: #"""
                    /// iPad Pro (12.9-inch) (6th generation)
                        public static let iPad14_6_B = Device(id: "iPad14,6-B", model: "iPad Pro (12.9-inch) (6th generation)")
                    """#
                )
            ),
            (
                given: (id: "iPhone15,3", name: "iPhone 14 Pro Max"),
                then: (
                    sanitized: "iPhone15_3",
                    caseItem: ".iPhone15_3",
                    propertyItem: #"""
                    /// iPhone 14 Pro Max
                        public static let iPhone15_3 = Device(id: "iPhone15,3", model: "iPhone 14 Pro Max")
                    """#
                )
            ),
            (
                given: (id: "AppleTV14,1", name: "Apple TV 4K (3rd generation)"),
                then: (
                    sanitized: "appleTV14_1",
                    caseItem: ".appleTV14_1",
                    propertyItem: #"""
                    /// Apple TV 4K (3rd generation)
                        public static let appleTV14_1 = Device(id: "AppleTV14,1", model: "Apple TV 4K (3rd generation)")
                    """#
                )
            ),
            (
                given: (id: "Watch6,18", name: "Apple Watch Ultra"),
                then: (
                    sanitized: "watch6_18",
                    caseItem: ".watch6_18",
                    propertyItem: #"""
                    /// Apple Watch Ultra
                        public static let watch6_18 = Device(id: "Watch6,18", model: "Apple Watch Ultra")
                    """#
                )
            ),
        ]

        zip(specs.map(\.given.id).map(sanitized), specs.map(\.then.sanitized))
            .forEach { actual, expected in
                XCTAssertEqual(actual, expected)
            }

        zip(specs.map(\.given.id).map { caseItem(sanitized($0)) }, specs.map(\.then.caseItem))
            .forEach { actual, expected in
                XCTAssertEqual(actual, expected)
            }

        zip(
            specs
                .map(\.given)
                .map { Device(name: $0.name, product: $0.id) }
                .map(\.codeBlock.propertyItem),
            specs
                .map(\.then.propertyItem)
        )
        .forEach { actual, expected in
            XCTAssertEqual(actual, expected)
        }
    }
}

struct FakeDevicesInfoProvider: DevicesInfoProvider {
    func devicesInfo() throws -> DevicesInfo {
        DevicesInfo(
            xcode: Xcode(appVersion: "14.2", buildNumber: "14C18"),
            platforms: [
                Platform(
                    id: .iPhoneOS,
                    devices: [
                        Device(name: "iPad (8th generation)", product: "iPad11,7"),
                        Device(name: "iPhone 14 Pro Max", product: "iPhone15,3"),
                    ]
                ),
                Platform(
                    id: .tvOS,
                    devices: [
                        Device(name: "Apple TV 4K (3rd generation)", product: "AppleTV14,1"),
                    ]
                ),
                Platform(
                    id: .watchOS,
                    devices: [
                        Device(name: "Apple Watch Ultra", product: "Watch6,18"),
                    ]
                ),
            ]
        )
    }
}

private let fileContentSnapshot = """
import Foundation

/*
 * Do not edit this file.
 * Generated from Xcode's Command-Line Tools databases - Xcode 14.2 (14C18).
 **/

/// The representation of the device running - it could be either physical or simulated.
/// > Generated from Xcode's Command-Line Tools databases - Xcode 14.2 (14C18).
public struct Device: Identifiable, Hashable, CaseIterable {
    /// The identifier for the device.
    public let id: String
    /// The known/commercial name of the device.
    public let model: String

    /// Creates a representation of a device.
    /// - Parameters:
    ///   - id: The identifier for the device.
    ///   - model: The known/commercial name of the device.
    init(id: String, model: String) {
        self.id = id
        self.model = model
    }

    /// Creates a representation of the device found in Xcode's databases based on the given device identifier.
    /// - Parameter id: The identifier for the device.
    init(id: String) {
        if let device = Device.allCases.first(where: { $0.id == id }) {
            self = device
        } else if let simulator = Device.simulators.first(where: { $0.id == id }) {
            self = simulator
        } else {
            self = .unknown
        }
    }

    /// Simulator instances.
    static let simulators: [Device] = {
        ["i386", "x86_64", "arm64"]
            .map { deviceId in
                Device(id: deviceId, model: "Simulator")
            }
    }()

    /// The device identifier read from the system info.
    static let deviceIdentifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(
            cString: [UInt8](
                Data(
                    bytes: &systemInfo.machine,
                    count: Int(_SYS_NAMELEN)
                )
            )
        )
    }()

    /// It is `true` when the device does not match either simulators or physical devices.
    public var isUnknown: Bool {
        self == .unknown
    }

    /// It is `true` when running on a simulator instance.
    public var isSimulator: Bool {
        Device.simulators.contains(self)
    }

    /// It is `true` when running on a physical device.
    public var isDevice: Bool {
        !isSimulator && !isUnknown
    }

    /// The current instance of the device that is running.
    public static let current = Device(id: deviceIdentifier)
    /// An unknown device instance.
    public static let unknown = Device(id: "unknown", model: "unknown")
    // # iPhoneOS
    /// iPad (8th generation)
    public static let iPad11_7 = Device(id: "iPad11,7", model: "iPad (8th generation)")
    /// iPhone 14 Pro Max
    public static let iPhone15_3 = Device(id: "iPhone15,3", model: "iPhone 14 Pro Max")
    // # tvOS
    /// Apple TV 4K (3rd generation)
    public static let appleTV14_1 = Device(id: "AppleTV14,1", model: "Apple TV 4K (3rd generation)")
    // # watchOS
    /// Apple Watch Ultra
    public static let watch6_18 = Device(id: "Watch6,18", model: "Apple Watch Ultra")

    public static let allCases: [Device] = [
        // # iPhoneOS
        .iPad11_7,
        .iPhone15_3,
        // # tvOS
        .appleTV14_1,
        // # watchOS
        .watch6_18
    ]
}
"""
