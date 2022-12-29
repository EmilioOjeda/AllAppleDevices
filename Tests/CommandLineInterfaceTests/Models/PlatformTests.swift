@testable import CommandLineInterface
import XCTest

final class PlatformTests: XCTestCase {
    func testEquatableAndHashableConformances() {
        func makePlatform() -> Platform {
            Platform(
                id: .iPhoneOS,
                devices: [Device(name: "name", product: "product")]
            )
        }

        let platform1 = makePlatform()
        let platform2 = makePlatform()
        XCTAssertEqual(platform1, platform2)

        let platformSet = Set([platform1, platform2])
        XCTAssertEqual(1, platformSet.count)
    }
}

final class PlatformIDTests: XCTestCase {
    func testHashableConformance() {
        let platformIdsSet = Set(Platform.ID.allCases)
        XCTAssertEqual(Platform.ID.allCases.count, platformIdsSet.count)

        XCTAssertTrue(
            Platform.ID
                .allCases
                .allSatisfy(platformIdsSet.contains)
        )
    }

    func testEquatableConformance() throws {
        XCTAssertEqual(Platform.ID.iPhoneOS, Platform.ID(rawValue: "iphoneos"))
        XCTAssertEqual(Platform.ID.tvOS, Platform.ID(rawValue: "tvos"))
        XCTAssertEqual(Platform.ID.watchOS, Platform.ID(rawValue: "watchos"))
    }

    func testIdentifiableByRawValue() {
        XCTAssertTrue(
            Platform.ID
                .allCases
                .map { platformId in
                    (id: platformId.id, rawValue: platformId.rawValue)
                }
                .allSatisfy(==)
        )
    }

    func testPackage() {
        typealias Spec = (given: Platform.ID, then: String)

        let specs: [Spec] = [
            (given: .iPhoneOS, then: "iPhoneOS.platform"),
            (given: .tvOS, then: "AppleTVOS.platform"),
            (given: .watchOS, then: "WatchOS.platform"),
        ]

        XCTAssertTrue(
            zip(specs.map(\.given.package), specs.map(\.then))
                .allSatisfy(==)
        )
    }

    func testDisplayName() {
        typealias Spec = (given: Platform.ID, then: String)

        let specs: [Spec] = [
            (given: .iPhoneOS, then: "iPhoneOS"),
            (given: .tvOS, then: "tvOS"),
            (given: .watchOS, then: "watchOS"),
        ]

        XCTAssertTrue(
            zip(specs.map(\.given.displayName), specs.map(\.then))
                .allSatisfy(==)
        )
    }
}
