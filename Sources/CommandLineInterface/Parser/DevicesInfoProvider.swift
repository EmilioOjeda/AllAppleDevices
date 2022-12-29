typealias DevicesInfo = (xcode: Xcode, platforms: [Platform])

protocol DevicesInfoProvider {
    func devicesInfo() throws -> DevicesInfo
}
