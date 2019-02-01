import Foundation

struct BingImageItem : Codable {
    let thumbnailUrl: String
}

struct BingPayload : Codable {
    let value: [BingImageItem]
}

struct FlickrPayload: Codable {
    let photos: ItemsWrapperStruct
}

struct ItemsWrapperStruct: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [FlickrImageItem]
}

struct FlickrImageItem: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    func path() -> String {
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
