//
//  ViewController.swift
//  image-dataset-app
//
//  Created by Krzysztof Langner on 16/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class DatasetImagesVC: UIViewController {

    @IBOutlet weak var currentDatasetLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.currentDataset(completion: {(dataset) in
            currentDatasetLabel.title = dataset.name
        })
    }

    // Switch to the view which will take new picture
    @IBAction func takePictureTapped(_ sender: Any) {
        print("Take picture")
    }
    
    @IBAction func selectDatasetTapped(_ sender: Any) {
        if let selectDatasetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectDatasetId") as? SelectDatasetVC {
            present(selectDatasetVC, animated: false, completion: nil)
        }
    }
    
}

