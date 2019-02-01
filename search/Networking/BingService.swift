import Foundation

class BingService {
    
    let session = URLSession(configuration: .default)
    
    func fetchImageItems(query: String, offset: Int, completion: @escaping ([BingImageItem]?) -> Void ) {
        
        let url = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=\(query)&count=\(8)&offset=\(offset)")!
        
        var request = URLRequest(url: url)
        
        request.setValue("9fb0c979b4344f3395cdce51b94a07a1", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        session.dataTask(with: request) { data, response, error in
        
            // show that responses can come out of sync
            //print(">>>>>>>.",  url["offset"] )
            
            let payload = try? JSONDecoder().decode( BingPayload.self, from: data!)
            let imageItems = payload?.value
            completion( imageItems )
            
        }.resume()
        
        
    }
}

//extension URL {
//    subscript(queryParam:String) -> String? {
//        guard let url = URLComponents(string: self.absoluteString) else { return nil }
//        return url.queryItems?.first(where: { $0.name == queryParam })?.value
//    }
//}
