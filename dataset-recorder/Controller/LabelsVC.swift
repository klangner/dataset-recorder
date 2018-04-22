//
//  DatasetLabelsVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 11/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class LabelsVC: UIViewController {
    
    var dataset: Dataset!

    @IBOutlet weak var labelTableView: UITableView!
    @IBOutlet weak var datasetNameLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasetNameLabel.title = dataset.name
        labelTableView.dataSource = self
        labelTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        editName(name: "", updateHandler: {(name) in
            _ = self.dataset.newLabel(name: name)
            self.labelTableView.reloadData()
        })
    }

    // Show alert which will allow to edit cell text
    // Return true if name should be changed
    func editName(name: String, updateHandler: @escaping (String) -> ()) {
        let alert = UIAlertController(title: "", message: "Label name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = name
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
            let name = alert.textFields!.first!.text!
            if !name.isEmpty {
                updateHandler(name)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        if let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as? SettingsVC {
            settingsVC.dataset = dataset
            present(settingsVC, animated: true, completion: nil)
        }
    }
}


extension LabelsVC : UITableViewDataSource, UITableViewDelegate {
    
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let labels = dataset?.labels {
            return labels.count
        } else {
            return 0
        }
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let labels = dataset.getLabels()
        cell.textLabel?.text = labels[indexPath.row].name
        return cell
    }
    
    // When the user swipes we want to show Edit and Delete actions
    // Delete is only shown if there is more then 1 row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            self.editLabel(at: indexPath)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            let labels = self.dataset.getLabels()
            let dataLabel = labels[indexPath.row]
            self.dataset.delete(label: dataLabel)
            self.labelTableView.reloadData()
        })
        return [deleteAction, editAction]
    }
    
    // Show alert which will allow to edit label
    func editLabel(at indexPath: IndexPath) {
        let labels = dataset.getLabels()
        let dataLabel = labels[indexPath.row]
        editName(name: dataLabel.name!, updateHandler: {(newName) in
            dataLabel.name = newName
            DataService.instance.save()
            self.labelTableView.reloadData()
        })
    }
    
}

