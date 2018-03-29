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
    
    var images: [ImageData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        DataService.instance.currentDataset(completion: {(dataset) in
            currentDatasetLabel.title = dataset.name
            loadData(from: dataset)
        })
    }

    // Switch to the view which will take new picture
    @IBAction func takePictureTapped(_ sender: Any) {
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            present(cameraVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func selectDatasetTapped(_ sender: Any) {
        if let selectDatasetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectDatasetId") as? SelectDatasetVC {
            present(selectDatasetVC, animated: false, completion: nil)
        }
    }
    
    func loadData(from dataset: Dataset) {
        DataService.instance.datasetImages(from: dataset){ images in
            self.images = images
        }
    }
}


extension DatasetVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Data count: \(images.count)")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Render cell")
        let imageData = images[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        cell.bounds.size = CGSize(width: 64, height: 64)
        cell.backgroundView?.backgroundColor = UIColor.red
        return cell
    }
}
