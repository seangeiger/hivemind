//
//  Geocoder.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation
import CoreLocation


class Geocoder {
    
    private static var tasks = 0
    
    private static let geocoder_queue = DispatchQueue(label: "geocoder")
    
    static var is_geocoding: Bool {
        return tasks > 0
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    static func geocode(_ string: String, callback: @escaping CLGeocodeCompletionHandler) {
        increment()
        CLGeocoder().geocodeAddressString(string) { placemarks, error in
            callback(placemarks, error)
            decrement()
        }
    }
    
    
    private static func increment() {
        Geocoder.geocoder_queue.async {
            tasks += 1
        }
    }
    
    
    private static func decrement() {
        Geocoder.geocoder_queue.async {
            tasks -= 1
            if tasks == 0 {
                NotificationCenter.default.post(name: .geocodeFinish, object: nil)
            }
        }
    }
    
    
    
}
