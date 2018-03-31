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
        let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId")
        present(cameraVC, animated: false, completion: nil)
    }
    
    @IBAction func selectDatasetTapped(_ sender: Any) {
        let selectDatasetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectDatasetId")
        present(selectDatasetVC, animated: false, completion: nil)
    }
    
    func loadData(from dataset: Dataset) {
        DataService.instance.datasetImages(from: dataset){ images in
            self.images = images
        }
    }
}


extension DatasetVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Get number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Get cell dimensions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width/4, height: width/3)
    }
    
    // Get cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = images[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? DataItemCell {
            cell.imageView.image = UIImage(data: imageData.image!)
            cell.dataLabel.text = imageData.label
            return cell
        }
        return DataItemCell()
    }
    
    // Tapped on cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageData = images[indexPath.item]
        if let editDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editDataVC") as? EditDataVC {
            editDataVC.dataItem = imageData
            present(editDataVC, animated: false, completion: nil)
        }
    }
}
