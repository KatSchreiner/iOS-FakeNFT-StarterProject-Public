import Foundation

enum Filters: String {
    case name = "allTrackers"
    case amount = "todayTrackers"
    
    static var defaultValue: Filters {
        return .amount
    }
}
