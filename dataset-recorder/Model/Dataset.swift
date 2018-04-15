//
//  Dataset.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 14/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit


extension Dataset {

    // Set last used property to now
    func touch() {
        self.lastUsed = Date()
        DataService.instance.save()
    }
    
    // Get list of labels
    // Get list of items for the given dataset
    func getLabels() -> [DataLabel] {
        if let labels = self.labels?.allObjects as? [DataLabel] {
            return labels
        }
        return []
    }
    
    // Add image item to the current dataset
    func add(image: UIImage, withLabel label: String) -> DataItem? {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return nil }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let item = DataItem(context: managedContext)
        let now = Date()
        let fileName = "image_\(now.isoFormat()).jpg"
        do {
            try saveToFile(data: data, name: fileName)
            item.dataset = self
            item.fileName = fileName
            item.preview = data
            item.label = label
            item.createdAt = now
            try managedContext.save()
        } catch {
            debugPrint("Can't save image \(error)")
            return nil
        }
        return item
    }

    // Save data to the file in the document directory
    private func saveToFile(data: Data, name: String) throws {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = docDir.appendingPathComponent(name)
        try data.write(to: url)
    }

}
