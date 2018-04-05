//
//  EditDataVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 31/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class EditDataVC: UIViewController {

    var dataItem: DataItem!
    
    @IBOutlet weak var dataLabel: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(contentsOfFile: dataItem.fileUrl().path)
        dataLabel.title = dataItem.label!
    }
    
    @IBAction func onLabelTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Edit label", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = self.dataItem.label!
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
            let name = alert.textFields!.first!.text!
            if !name.isEmpty {
                self.dataLabel.title = name
                self.dataItem.label = name
                DataService.instance.save()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
    


    @IBAction func onDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            DataService.instance.deleteItem(item: self.dataItem)
            self.moveBack()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
    
    @IBAction func onBack(_ sender: Any) {
        moveBack()
    }
    
    func moveBack() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "datasetImagesId")
        present(vc, animated: false, completion: nil)
    }
}
