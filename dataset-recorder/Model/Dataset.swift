//
//  Dataset.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 14/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit
import CoreData


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
            return labels.sorted(by: { $0.name! < $1.name! })
        }
        return []
    }
    
    // Add label to the dataset
    func newLabel(name: String) -> DataLabel? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataLabel = DataLabel(context: managedContext)
        dataLabel.dataset = self
        dataLabel.name = name
        do {
            try managedContext.save()
        } catch {
            debugPrint("Can't save label \(error)")
            return nil
        }
        return dataLabel
    }
    
    // Delete label
    func delete(label dataLabel: DataLabel) {
        let managedContext = DataService.instance.context()
        managedContext.delete(dataLabel)
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not delete object \(error.localizedDescription)")
        }
    }
    
    // Add image item to the current dataset
    func newImageItem(image: UIImage, withLabel label: String) -> DataItem? {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return nil }
        let managedContext = DataService.instance.context()
        let item = DataItem(context: managedContext)
        let fileName = UUID().uuidString.lowercased() + ".jpg"
        do {
            try saveToFile(data: data, name: fileName)
            item.dataset = self
            item.fileName = fileName
            item.preview = data
            item.label = label
            item.createdAt = Date()
            try managedContext.save()
        } catch {
            debugPrint("Can't save image \(error)")
            return nil
        }
        return item
    }
    
    // Get list of items for the given dataset
    func getItems() -> [DataItem]{
        if let items = self.items?.allObjects as? [DataItem] {
            return items
        }
        return []
    }
    
    // Delete data item
    func delete(item: DataItem) {
        let managedContext = DataService.instance.context()
        managedContext.delete(item)
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let url = docDir.appendingPathComponent(item.fileName!)
            try FileManager.default.removeItem(at: url)
            try managedContext.save()
        } catch {
            debugPrint("Could not delete object \(error.localizedDescription)")
        }
    }
    
    // Delete multiple data items
    func delete(items: [DataItem]) {
        let managedContext = DataService.instance.context()
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            for item in items {
                let url = docDir.appendingPathComponent(item.fileName!)
                managedContext.delete(item)
                try FileManager.default.removeItem(at: url)
            }
            try managedContext.save()
        } catch {
            debugPrint("Could not delete object \(error.localizedDescription)")
        }
    }

    // Save data to the file in the document directory
    private func saveToFile(data: Data, name: String) throws {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = docDir.appendingPathComponent(name)
        try data.write(to: url)
    }

}
