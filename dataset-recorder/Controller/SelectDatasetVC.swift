//
//  SelectDatasetVCViewController.swift
//  image-dataset-app
//
//  Created by Krzysztof Langner on 17/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class SelectDatasetVC: UIViewController {


    @IBOutlet weak var datasetsTableView: UITableView!
    
    // Cache for dataset names
    var datasetNames = [Dataset]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasetsTableView.dataSource = self
        datasetsTableView.delegate = self
        loadDatasets()
    }
    
    func loadDatasets() {
        DataService.instance.fetchDatasets(){ datasets in
            self.datasetNames = datasets
            self.datasetsTableView.reloadData()
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        showDatasetImagesVC()
    }
    
    @IBAction func addNameTapped(_ sender: UIBarButtonItem) {
        editName(name: "", updateHandler: {(name) in
            let dataset = DataService.instance.addDataset(withName: name)
            self.selectDataset(dataset: dataset)
        })
    }
    
    func selectDataset(dataset: Dataset) {
        dataset.touch()
        showDatasetImagesVC()
    }
    
    // Go back to main view controller
    func showDatasetImagesVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "datasetVC")
        present(vc, animated: false, completion: nil)
    }
    
    // Show alert which will allow to edit cell text
    // Return true if name should be changed
    func editName(name: String, updateHandler: @escaping (String) -> ()) {
        let alert = UIAlertController(title: "", message: "Edit Dataset name", preferredStyle: .alert)
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

    
}

extension SelectDatasetVC : UITableViewDataSource, UITableViewDelegate {

    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasetNames.count
    }

    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatasetNameCell", for: indexPath)
        let dataset = datasetNames[indexPath.row]
        cell.textLabel?.text = dataset.name
        if indexPath.row == 0 {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    // When user taps on datset, then select it and go back to main VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataset = datasetNames[indexPath.row]
        selectDataset(dataset: dataset)
    }
    
    // When the user swipes we want to show Edit and Delete actions
    // Delete is only shown if there is more then 1 row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            self.editCell(at: indexPath)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            DataService.instance.remove(dataset: self.datasetNames[indexPath.row])
            self.loadDatasets()
        })
        
        if datasetNames.count > 1 { return [deleteAction, editAction] }
        else { return [editAction] }
    }
    
    // Show alert which will allow to edit cell text
    func editCell(at indexPath: IndexPath) {
        let dataset = datasetNames[indexPath.row]
        editName(name: dataset.name!, updateHandler: {(newName) in
            dataset.name = newName
            DataService.instance.save()
            self.loadDatasets()
            self.datasetsTableView.reloadRows(at: [indexPath], with: .fade)
        })
    }
}

