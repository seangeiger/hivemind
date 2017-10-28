//
//  ContentLoader.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation
import UIImageColors

class ContentLoader {
    
    static let default_key = "default_image"
    
    static let default_image = UIImage(named: "bg_3")
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    
    static func fetchImage(url: String?, callback: @escaping (CDImage) -> ()) {
        guard let url = url else {
            callback(getDefaultImage())
            return
        }
        
        if CACHE_IMAGES, let image = CDImage.fetch(url: url) {
            callback(image)
            return
        }
        
        if let url_object = URL(string: url) {
            DispatchQueue.global(qos: .userInteractive).async {
                var cd_image: CDImage? = nil
                if let data = NSData(contentsOf: url_object) {
                    if (data as Data).contentType() == .gif, let gif = UIImage.animatedImage(withAnimatedGIFData: data as Data) {
                        cd_image = CDImage.init(url: url, image: gif)
                    } else if let image = UIImage(data: data as Data) {
                        cd_image = CDImage.init(url: url, image: image)
                    }
                }
                callback(cd_image ?? getDefaultImage())
            }
        }
    }
    
    
    static func getDefaultImage() -> CDImage {
        if let image = CDImage.fetch(url: ContentLoader.default_key) {
            return image
        }
        
        // Create image (which also adds it to Core Data)
        let colors = UIImageColors(background: Color.royal, primary: Color.white, secondary: Color.white, detail: Color.gray)
        return CDImage.init(url: ContentLoader.default_key, image: ContentLoader.default_image!, colors: colors)
    }
    
    
    
    
    
    
    
}
