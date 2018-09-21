import Foundation

public struct TemperaturModel {
    public let minTemC: Float?
    public let maxTemC: Float?
    public let temC: Float?

    public init(minTemC: Float?,
                maxTemC: Float?,
                temC: Float?) {
        self.minTemC = minTemC
        self.maxTemC = maxTemC
        self.temC = temC
    }
}
