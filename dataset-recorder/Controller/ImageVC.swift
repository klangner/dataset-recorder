//
//  ImageEditVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 24/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    var dataset: Dataset!
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.currentDataset { (dataset) in
            self.dataset = dataset
        }
        imageView.image = image
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        moveToCameraVC()
    }
    
    // Edit label and save image
    @IBAction func onLabelTapped(_ sender: Any) {
        let labels = DataService.instance.datasetLabels(from: dataset)
        let alertView = UIAlertController(title: "Image label", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 200))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(pickerView)
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
            let row = pickerView.selectedRow(inComponent: 0)
            let name = labels[row].name!
            if !name.isEmpty {
                DataService.instance.addImage(image: self.image!, withLabel: name)
                self.moveToCameraVC()
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: { () in
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }

    func moveToCameraVC() {
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            present(cameraVC, animated: false, completion: nil)
        }
    }
}

extension ImageVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let labels = DataService.instance.datasetLabels(from: dataset)
        return labels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let labels = DataService.instance.datasetLabels(from: dataset)
        return labels[row].name!
    }
    
}
