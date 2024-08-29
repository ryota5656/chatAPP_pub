import FirebaseFirestore
import Foundation

struct User: Decodable, Identifiable{
    let id: String
    var name: String
    var image: String
}
