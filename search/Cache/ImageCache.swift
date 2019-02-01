//
//  ImageCache.swift
//  history
//
//  Created by tati on 1/19/19.
//  Copyright © 2019 ps. All rights reserved.
//

import Foundation
import UIKit

struct ImageCache {
    
    var cache = NSCache<NSString, UIImage>()
    
    func fetchImage(named urlString: String, completion: (UIImage) -> Void) {
        
        if let image = cache.object(forKey: urlString as NSString)  {
            completion( image )
            return
        }

        let url = URL(string: urlString)!
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)!
            
            DispatchQueue.main.async {
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
            }
            
            completion( image )
        }
        catch {
            completion( screenshot()! )
        }
        
    }
    
    private func screenshot(_ shouldSave: Bool = false) -> UIImage? {
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
