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
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            present(cameraVC, animated: false, completion: nil)
        }
    }
}
