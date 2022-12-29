public struct Platform: Hashable, Identifiable {
    public enum ID: String, Hashable, Identifiable, CaseIterable {
        case iPhoneOS = "iphoneos"
        case tvOS = "tvos"
        case watchOS = "watchos"

        public var id: String { rawValue }

        public var package: String {
            switch self {
            case .iPhoneOS: return "iPhoneOS.platform"
            case .tvOS: return "AppleTVOS.platform"
            case .watchOS: return "WatchOS.platform"
            }
        }

        public var displayName: String {
            switch self {
            case .iPhoneOS: return "iPhoneOS"
            case .tvOS: return "tvOS"
            case .watchOS: return "watchOS"
            }
        }
    }

    public let id: ID
    public let devices: [Device]
}
