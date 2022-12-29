@testable import CommandLineInterface
import XCTest

private let fakeName1 = "name-one"
private let fakeName2 = "name-two"
private let fakeProduct1 = "product-one"
private let fakeProduct2 = "product-two"

final class DeviceTests: XCTestCase {
    func testHashableConformance() {
        let firstSet = Set(
            (1 ... 5)
                .map { _ in
                    Device(name: fakeName1, product: fakeProduct1)
                }
        )
        XCTAssertEqual(1, firstSet.count)

        let secondSet = Set(
            (1 ... 5)
                .map { _ in
                    Device(name: fakeName2, product: fakeProduct2)
                }
        )
        XCTAssertEqual(1, secondSet.count)

        let mergeOfSets = firstSet.union(secondSet)
        XCTAssertEqual(2, mergeOfSets.count)
        XCTAssertEqual(0, firstSet.intersection(secondSet).count)
    }

    func testEquatableConformance() {
        typealias Spec = (given: (lhs: Device, rhs: Device), when: (Device, Device) -> Bool, then: Bool)

        let specs: [Spec] = [
            (
                given: (
                    lhs: Device(name: fakeName1, product: fakeProduct1),
                    rhs: Device(name: fakeName2, product: fakeProduct2)
                ),
                when: !=,
                then: true
            ),
            (
                given: (
                    lhs: Device(name: fakeName1, product: fakeProduct1),
                    rhs: Device(name: fakeName1, product: fakeProduct1)
                ),
                when: ==,
                then: true
            ),
            (
                given: (
                    lhs: Device(name: fakeName2, product: fakeProduct2),
                    rhs: Device(name: fakeName2, product: fakeProduct2)
                ),
                when: ==,
                then: true
            ),
        ]

        zip(
            specs
                .map { spec in
                    let (lhs, rhs) = spec.given
                    return spec.when(lhs, rhs)
                },
            specs.map(\.then)
        )
        .forEach { actual, expected in
            XCTAssertEqual(actual, expected)
        }
    }

    func testIdentifiableByProduct() {
        let device = Device(name: fakeName1, product: fakeProduct1)
        XCTAssertEqual(device.id, device.product)
    }
}
