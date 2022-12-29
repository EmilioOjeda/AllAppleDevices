import Algorithms
import SQLite

private extension Expression where Datatype == String {
    static let name = Expression<String>("ProductDescription")
    static let product = Expression<String>("ProductType")
}

func database(commandLineTool path: String, platform package: String) -> String {
    "\(path)/Platforms/\(package)/usr/standalone/device_traits.db"
}

struct DevicesInfoProviderSQLite: DevicesInfoProvider {
    let platformIDs: [Platform.ID]
    let xcodebuildVersion: String
    let commandLineToolPath: String

    func devicesInfo() throws -> DevicesInfo {
        DevicesInfo(
            xcode: Xcode(xcodebuildVersion: xcodebuildVersion),
            platforms: try platformIDs
                .map { id in
                    let database = database(commandLineTool: commandLineToolPath, platform: id.package)
                    let connection = try Connection(database, readonly: true)

                    let devices = try connection
                        .prepare(Table("Devices"))
                        .map { row in Device(name: row[.name], product: row[.product]) }
                        .uniqued(on: \.id)

                    return Platform(id: id, devices: devices)
                }
        )
    }
}
