@testable import CommandLineInterface
import XCTest

private let fakeAppVersion = "14.2"
private let fakeBuildVersion = "14C18"
private let fakeAppVersionInfo = "Xcode \(fakeAppVersion)"
private let fakeBuildVersionInfo = "Build version \(fakeBuildVersion)"

final class XcodeTests: XCTestCase {
    func testInitializers() {
        typealias Spec = (given: String, then: Xcode)

        let specs: [Spec] = [
            Spec(
                given: "",
                then: .unknown
            ),
            Spec(
                given: "\(fakeAppVersionInfo) \(fakeBuildVersionInfo)",
                then: .unknown
            ),
            Spec(
                given: """
                \(fakeAppVersionInfo)
                \(fakeBuildVersionInfo)
                """,
                then: Xcode(appVersion: fakeAppVersion, buildNumber: fakeBuildVersion)
            ),
        ]

        zip(specs.map(\.given), specs.map(\.then))
            .forEach { actual, expected in
                XCTAssertEqual(
                    expected,
                    Xcode(xcodebuildVersion: actual)
                )
            }
    }

    func testHashableConformance() {
        func testHashableConformance() {
            let set = Set(
                (1 ... 5)
                    .map { _ in
                        Xcode(appVersion: fakeAppVersion, buildNumber: fakeBuildVersion)
                    }
            )
            XCTAssertEqual(1, set.count)
        }
    }

    func testEquatableConformance() {
        let elements = (1 ... 2)
            .map { offset in
                Xcode(
                    appVersion: "app-version-\(offset)",
                    buildNumber: "build-number-\(offset)"
                )
            }
        XCTAssertNotEqual(elements[0], elements[1])
    }
}
