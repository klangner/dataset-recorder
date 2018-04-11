//
//  DatasetLabelsVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 11/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class LabelsVC: UIViewController {
    
    let labels = ["red", "blue", "green", "yellow"]

    @IBOutlet weak var labelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTableView.dataSource = self
        labelTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension LabelsVC : UITableViewDataSource, UITableViewDelegate {
    
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cellForRow(at: indexPath) else { return UITableViewCell() }
        cell.textLabel?.text = labels[indexPath.row]
        return cell
    }
    
    // When the user swipes we want to show Edit and Delete actions
    // Delete is only shown if there is more then 1 row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            self.editLabel(at: indexPath)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
//            DataService.instance.removeDataset(dataset: self.datasetNames[indexPath.row], completion: { (deleted) in
//                if deleted {
//                    self.loadDatasets()
//                }
//            })
        })
        if labels.count > 1 { return [deleteAction, editAction] }
        else { return [editAction] }
    }
    
    // Show alert which will allow to edit label
    func editLabel(at indexPath: IndexPath) {
//        let dataset = datasetNames[indexPath.row]
//        editName(name: dataset.name!, updateHandler: {(newName) in
//            dataset.name = newName
//            DataService.instance.save()
//            self.loadDatasets()
//            self.datasetsTableView.reloadRows(at: [indexPath], with: .fade)
//        })
    }
}

