import Foundation

class FlickrService {
    
    let key = "3e7cc266ae2b0e0d78e279ce8e361736"
    let session = URLSession(configuration: .default)
    
    func fetchImageItems(query: String, offset: Int, completion: @escaping ([FlickrImageItem]?) -> Void ) {
        
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&format=json&nojsoncallback=1&safe_search=\(offset)&text=\(query)")!
        
        let request = URLRequest(url: url)
        
        // request.setValue("9fb0c979b4344f3395cdce51b94a07a1", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        session.dataTask(with: request) { data, response, error in
            
            // show that responses can come out of sync
            //print(">>>>>>>.",  url["offset"] )
            
            let payload = try? JSONDecoder().decode( FlickrPayload.self, from: data!)
            let imageItems = payload?.photos.photo
            completion( imageItems )
            
            }.resume()
    }
}
