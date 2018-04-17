//
//  ViewController.swift
//  image-dataset-app
//
//  Created by Krzysztof Langner on 16/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class DatasetVC: UIViewController {

    @IBOutlet weak var currentDatasetLabel: UIBarButtonItem!
    @IBOutlet weak var dataCollectionView: UICollectionView!

    // Cache for dataset items
    var dataset: Dataset!
    var dataItems: [DataItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        DataService.instance.recentDataset(completion: {(dataset) in
            self.dataset = dataset
            currentDatasetLabel.title = dataset.name
            loadData(from: dataset)
        })
    }

    // Switch to the view which will take new picture
    @IBAction func takePictureTapped(_ sender: Any) {
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            cameraVC.dataset = dataset
            present(cameraVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        let dataUrls = dataItems.map { (dataItem) in dataItem.fileUrl() }
        let urls = dataUrls + [datasetCsv()]
        let activityViewController = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = dataSharedHandler
        activityViewController.excludedActivityTypes = [
            UIActivityType.airDrop,
            UIActivityType.postToFacebook,
            UIActivityType.assignToContact,
            UIActivityType.copyToPasteboard,
            UIActivityType.mail,
            UIActivityType.message,
            UIActivityType.addToReadingList,
            UIActivityType.print]

        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Create file in temp directory with CSV data for current dataset
    func datasetCsv() -> URL {
        let fileName = "dataset_\(Date().timeIntervalSince1970).csv"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var text = "file,label\n"
        for dataItem in dataItems {
            text += "\(dataItem.fileName!),\(dataItem.label!)\n"
        }
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            debugPrint("Can't creare dataset.csv: \(error)")
        }
        return fileURL
    }
    
    // After data has been send to the other application we will remove it from dataset on the device
    // The reason for this is to not send the same data multiple times
    func dataSharedHandler(_ activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) {
        FileManager.default.clearTmpDirectory()
        if completed {
            dataset.delete(items: dataItems)
            DataService.instance.recentDataset(completion: { (dataset) in
                loadData(from: dataset)
            })
        }
    }
    
    // Show controller with dataset selection
    @IBAction func selectDatasetTapped(_ sender: Any) {
        let selectDatasetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectDatasetId")
        present(selectDatasetVC, animated: false, completion: nil)
    }
    
    // Load dataset items
    func loadData(from dataset: Dataset) {
        dataItems = dataset.getItems()
        dataCollectionView.reloadData()
    }
}


// Extension for working with collection view
extension DatasetVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Get number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    // Get cell dimensions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width/4, height: width/3)
    }
    
    // Get cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = dataItems[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? DataItemCell {
            cell.imageView.image = UIImage(data: imageData.preview!)
            cell.dataLabel.text = imageData.label
            return cell
        }
        return DataItemCell()
    }
    
    // Tapped on cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageData = dataItems[indexPath.item]
        if let editDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editDataVC") as? EditDataVC {
            editDataVC.dataItem = imageData
            present(editDataVC, animated: false, completion: nil)
        }
    }
}
