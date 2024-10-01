import Foundation

struct NftById: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
    
    func getImageUrl() -> URL? {
        guard let mainImage = images.first else {
            print("Image is unavailable")
            return nil
        }
        return URL(string: mainImage)
    }
}
