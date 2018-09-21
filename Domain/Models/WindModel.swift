import Foundation

public struct WindModel {
    public let direction: String
    public let velocity: Float

    public init(direction: String, velocity: Float) {
        self.direction = direction
        self.velocity = velocity
    }
}
