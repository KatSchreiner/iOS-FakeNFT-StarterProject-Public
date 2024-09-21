import Foundation

// MARK: FilterStorageProtocol
protocol FilterStorageProtocol {
    func saveFilter(_ filter: Filters)
    func loadFilter() -> Filters
}

// MARK: FilterStorage
final class FilterStorage: FilterStorageProtocol {
    
    // MARK: Private properties
    private let filterKey = "selectedFilter"

    // MARK: Public methods
    func saveFilter(_ filter: Filters) {
        UserDefaults.standard.set(filter.rawValue, forKey: filterKey)
    }

    func loadFilter() -> Filters {
        if let savedFilterString = UserDefaults.standard.string(forKey: filterKey),
           let savedFilter = Filters(rawValue: savedFilterString) {
            return savedFilter
        } else {
            return Filters.defaultValue
        }
    }
}
