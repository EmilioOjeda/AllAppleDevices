public struct Device: Hashable, Identifiable {
    public let name: String
    public let product: String

    public var id: String { product }
}
