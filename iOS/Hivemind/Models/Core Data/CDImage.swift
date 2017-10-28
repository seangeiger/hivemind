//
//  CDImage.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation
import CoreData
import UIImageColors

public class CDImage: NSManagedObject {
    
    static let ENTITY_NAME = "Image"
    
    @NSManaged public var url:        String
    @NSManaged public var timestamp:  Date
    @NSManaged public var image:      UIImage
    @NSManaged public var colors_raw: [Data]
    
    var colors: UIImageColors!
    
    var summary: String {
        return "[\(self.timestamp.midStyle)] \t \(self.url.afterLast("/"))"
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    convenience init(url: String, image: UIImage) {
        self.init(url: url, image: image, colors: image.getColors())
    }
    
    
    init(url: String, image: UIImage, colors: UIImageColors) {
        let entity = NSEntityDescription.entity(forEntityName: CDImage.ENTITY_NAME, in: CoreDataManager.shared.managedObjectContext)!
        super.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
        
        self.url = CDImage.shorten(url)
        self.image = image
        self.timestamp = Date()
        self.colors = colors
        self.colors_raw = [colors.background.encode(), colors.primary.encode(), colors.secondary.encode(), colors.detail.encode()]
        
        CoreDataManager.shared.saveContext()
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    private static func get(predicate: NSPredicate? = nil) -> [CDImage]? {
        let request = NSFetchRequest<CDImage>(entityName: CDImage.ENTITY_NAME)
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            let images = try CoreDataManager.shared.managedObjectContext.fetch(request) as [CDImage]
            for image in images {
                let colors = image.colors_raw.map({UIColor.color(withData: $0)})
                image.colors = UIImageColors(background: colors[0], primary: colors[1], secondary: colors[2], detail: colors[3])
            }
            return images
            
        } catch {
            return nil
        }
    }
    
    
    private static func delete(_ image: CDImage) {
        CoreDataManager.shared.managedObjectContext.delete(image)
        debugPrint("Deleting \(image.summary)")
    }
    
    
    private static func shorten(_ url: String) -> String {
        if let range = url.range(of: "?") {
            return String(url[..<range.lowerBound])
        }
        return url
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    static func fetch(url: String) -> CDImage? {
        if let images = get(predicate: NSPredicate(format: "url == %@", CDImage.shorten(url))) {
            return images.first
        } else {
            return nil
        }
    }
    
    
    static func purgeExpired() {
        let two_days = NSDate(timeIntervalSinceNow: -(60 * 60 * 24 * 2))
        
        if let images = get(predicate: NSPredicate(format: "timestamp < %@", two_days)) {
            for expired_image in images {
                delete(expired_image)
            }
            CoreDataManager.shared.saveContext()
        }
    }
    
    
    static func purgeAll() {
        if let images = get() {
            for image in images {
                delete(image)
            }
            CoreDataManager.shared.saveContext()
        }
    }
    
    
    static func printAll() {
        guard let images = get() else {
            return
        }
        
        print("----- IMAGE CACHE (size: \(images.count)) ------------------------------------")
        for image in images {
            print(image.summary)
        }
        print("-----------------------------------------------------------------")
    }
    
    
}
