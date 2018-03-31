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
    
    @IBOutlet weak var imageView: UIImageView!
    
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
            textField.text = ""
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
            let name = alert.textFields!.first!.text!
            if !name.isEmpty {
                DataService.instance.addImage(image: self.imageView.image!, withLabel: name)
                self.moveToCameraVC()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }

    func moveToCameraVC() {
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            present(cameraVC, animated: false, completion: nil)
        }
    }
}
