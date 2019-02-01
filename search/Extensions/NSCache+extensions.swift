import Foundation
import UIKit

@objc extension NSCache {
    
    @objc func fetchImage(named urlString: String, completion: (UIImage) -> Void) {
        
//        if let image = self.object(forKey: urlString as! KeyType)  {
//            completion( image as! UIImage )
//            return
//        }
//        
        let url = URL(string: urlString)!
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)!
            completion( image )
        }
        catch {
            completion( screenshot()! )
        }
        
    }
    
    @objc private func screenshot(_ shouldSave: Bool = false) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale / 8
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
}
