//
//  ImageSizeVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 08/05/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class ImageSizeVC: UIViewController {

    var dataset: Dataset!
    
    @IBOutlet weak var imageSizeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Image Size"
        imageSizeTableView.dataSource = self
        imageSizeTableView.delegate = self
    }
}

extension ImageSizeVC : UITableViewDataSource, UITableViewDelegate {
    
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSizeCell", for: indexPath)
        switch indexPath.row {
        case 1:
            cell.textLabel?.text = ImageSize.hd1920x1080.rawValue
        default:
            cell.textLabel?.text = ImageSize.square480.rawValue
        }
        if dataset.imageSize == cell.textLabel?.text {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // When user taps on an image size then save size and go back to settings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            dataset.imageSize = ImageSize.square480.rawValue
        } else {
            dataset.imageSize = ImageSize.hd1920x1080.rawValue
        }
        DataService.instance.save()
        _ = navigationController?.popViewController(animated: true)
    }

}

