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
    @IBOutlet weak var labelsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        labelsTableView.dataSource = self
        labelsTableView.delegate = self
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        moveToCameraVC()
    }
    
    func moveToCameraVC() {
        if let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as? CameraVC {
            present(cameraVC, animated: false, completion: nil)
        }
    }
}

extension ImageVC: UITableViewDelegate, UITableViewDataSource {
    
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let labels = dataset?.labels else { return 0 }
        return labels.count
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditLabelCell", for: indexPath)
        let labels = dataset.getLabels()
        cell.textLabel?.text = labels[indexPath.row].name
        return cell
    }
    
    // After row is selected we want to save image and go back to camera view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let labels = dataset.getLabels()
        let dataLabel = labels[indexPath.row]
        _ = dataset.add(image: self.image!, withLabel: dataLabel.name!)
        self.moveToCameraVC()
    }
}
