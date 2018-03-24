//
//  DataService.swift
//  image-dataset-app
//
//  Created by Krzysztof Langner on 19/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit
import CoreData


class DataService {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let instance = DataService()
    
    func currentDataset(completion: (Dataset) -> ()) {
        fetchDatasets(completion: {(datasets) in
            if datasets.count > 0 { completion(datasets[0])}
            else { self.addDataset(withName: "My Dataset", completion: completion) }
        })
    }

    // To make dataset current one all we need to do is change it lastUsed date to now
    // Since current dataset is the one last used
    func setCurrentDataset(dataset: Dataset, completion: (Dataset) -> ()) {
        let managedContext = appDelegate.persistentContainer.viewContext
        dataset.lastUsed = Date()
        do {
            try managedContext.save()
            completion(dataset)
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
    func removeDataset(dataset: Dataset, completion: (Bool) -> ()) {
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(dataset)
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not delete object \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Add new dataset with given name
    func addDataset(withName name: String, completion: (Dataset) -> ()) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataset = Dataset(context: managedContext)
        dataset.name = name
        dataset.lastUsed = Date()
        do {
            try managedContext.save()
            completion(dataset)
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
        }
    }
    
    // Rename dataset. This can be done only if there is no dataset with this name yet
    func rename(dataset: Dataset, newName: String, completion: (Dataset) -> ()) {
        let managedContext = appDelegate.persistentContainer.viewContext
        dataset.name = newName
        do {
            try managedContext.save()
            completion(dataset)
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
        }
    }
}
