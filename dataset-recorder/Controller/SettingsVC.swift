//
//  SettingsVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 22/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    var dataset: Dataset!
    let options = ["Labels"]
    
    @IBOutlet weak var datasetNameLabel: UIBarButtonItem!
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.recentDataset { (dataset) in
            self.dataset = dataset
            datasetNameLabel.title = dataset.name
        }
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
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

extension SettingsVC : UITableViewDataSource, UITableViewDelegate {
    
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    // When user taps on an option then show detail view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLabelsVC()
    }
    
    func showLabelsVC() {
        if let labelsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "labelsVC") as? LabelsVC {
            labelsVC.dataset = dataset
            present(labelsVC, animated: true, completion: nil)
        }
    }
}

