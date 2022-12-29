@testable import CommandLineInterface
import XCTest

final class DatabaseTests: XCTestCase {
    func testFunction() {
        let fakePlatformPackage = "iPhoneOS.platform"
        let fakeCommandLineToolPath = "/Applications/Xcode.app/Contents/Developer"

        let database = database(commandLineTool: fakeCommandLineToolPath, platform: fakePlatformPackage)

        XCTAssertEqual(
            database,
            "\(fakeCommandLineToolPath)/Platforms/\(fakePlatformPackage)/usr/standalone/device_traits.db"
        )
    }
}
