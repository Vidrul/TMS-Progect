//
//  UIImageViewExtensions.swift
//  ChatApp2
//
//  Created by David Saley on 5/12/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download(в противном случае запустить новую загрузку)
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //download hit an error so lets return out
            guard error == nil  else {return}
            
            DispatchQueue.main.async {
                
                if let downLoadedImage = UIImage(data: data!) {
                    imageCache.setObject(downLoadedImage, forKey: urlString as NSString)
                    self.image = downLoadedImage
                }
            }
        }.resume()
    }
}
