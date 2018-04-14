//
//  DataService.swift
//
//  Created by Krzysztof Langner on 19/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit
import CoreData

enum DatasetType: String {
    case image, sensor, sound
}


class DataService {
    
    // Size of the preview image
    let previewSize = CGSize(width: 256, height: 512)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let instance = DataService()
    
    // Private init
    private init() {}
    
    // Get recently used dataset
    func recentDataset(completion: (Dataset) -> ()) {
        fetchDatasets(completion: {(datasets) in
            if datasets.count > 0 {
                completion(datasets[0])
            } else {
                completion(addDataset(withName: "My Dataset"))
            }
        })
    }

    // Set the dataset as current and change lastUsed date
    func setCurrentDataset(dataset: Dataset) {
        let managedContext = appDelegate.persistentContainer.viewContext
        dataset.lastUsed = Date()
        do {
            dataset.type = DatasetType.image.rawValue
            try managedContext.save()
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
        }
    }
    
    // Return all stored datasets
    func fetchDatasets(completion: ([Dataset]) -> ()) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Dataset>(entityName: "Dataset")
        let sort = NSSortDescriptor(key: #keyPath(Dataset.lastUsed), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            let datasets: [Dataset] = try managedContext.fetch(fetchRequest)
            completion(datasets)
        } catch {
            debugPrint("Can fetch Datasets \(error.localizedDescription)")
        }
    }
    
    // Remove dataset if it is empty
    func remove(dataset: Dataset) {
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(dataset)
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not delete object \(error.localizedDescription)")
        }
    }
    
    // Add new dataset with given name
    func addDataset(withName name: String) -> Dataset {
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataset = Dataset(context: managedContext)
        dataset.name = name
        dataset.lastUsed = Date()
        dataset.type = DatasetType.image.rawValue
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
        }
        return dataset
    }
    
    // Get list of items for the given dataset
    func datasetItems(from dataset: Dataset) -> [DataItem]{
        if let items = dataset.items?.allObjects as? [DataItem] {
            return items
        }
        return []
    }

    // Add image item to the current dataset
    func addImage(image: UIImage, withLabel label: String) {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        recentDataset(completion: { (dataset) in
            let managedContext = appDelegate.persistentContainer.viewContext
            let item = DataItem(context: managedContext)
            let now = Date()
            let fileName = "image_\(now.isoFormat()).jpg"
            do {
                try saveToFile(data: data, name: fileName)
                item.dataset = dataset
                item.fileName = fileName
                item.preview = data
                item.label = label
                item.createdAt = now
                try managedContext.save()
            } catch {
                debugPrint("Can't save image \(error)")
            }
        })
    }
    
    // Add image item to the current dataset
    func addLabel(to dataset: Dataset, with name: String) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataLabel = DataLabel(context: managedContext)
        dataLabel.dataset = dataset
        dataLabel.name = name
        do {
            try managedContext.save()
        } catch {
            debugPrint("Can't save label \(error)")
        }
    }
    
    private func saveToFile(data: Data, name: String) throws {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = docDir.appendingPathComponent(name)
        try data.write(to: url)
    }
    
    // Save all modifications
    func save() {
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch {
            debugPrint("Can't save image")
        }
    }
    
    // Delete data item
    func deleteItem(item: DataItem) {
        let managedContext = appDelegate.persistentContainer.viewContext
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
    func deleteItems(items: [DataItem]) {
        let managedContext = appDelegate.persistentContainer.viewContext
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

    // Get list of items for the given dataset
    func datasetLabels(from dataset: Dataset) -> [DataLabel]{
        if let labels = dataset.labels?.allObjects as? [DataLabel] {
            return labels
        }
        return []
    }
    
    // Delete label
    func delete(label dataLabel: DataLabel) {
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(dataLabel)
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not delete object \(error.localizedDescription)")
        }
    }
    
}
