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
    
    func context() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
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
    
    // Save all modifications
    func save() {
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch {
            debugPrint("Can't save image")
        }
    }
}
