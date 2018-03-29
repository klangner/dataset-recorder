//
//  ImageEditVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 24/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    var image: UIImage?
    
    @IBOutlet weak var labelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        moveToCameraVC()
    }
    
    @IBAction func onLabelTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Edit image label", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = self.saveButton.isEnabled ? self.labelButton.title : ""
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
            let name = alert.textFields!.first!.text!
            if !name.isEmpty {
                self.labelButton.title = name
                self.saveButton.isEnabled = true
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }

    // Add image to the dataset
    @IBAction func onSaveTapped(_ sender: Any) {
        DataService.init().addImage(image: imageView.image!, withLabel: labelButton.title!)
        moveToCameraVC()
    }
    
    func moveToCameraVC() {
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            present(cameraVC, animated: false, completion: nil)
        }
    }
}
