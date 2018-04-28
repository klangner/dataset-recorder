//
//  SettingsVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 22/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

struct Option {
    let title: String
    let segueName: String?
}

class SettingsVC: UIViewController {

    var dataset: Dataset!
    // List of options presented as a settings
    var options: [Option] = []
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.recentDataset { (dataset) in
            self.dataset = dataset
        }
        options = buildSettingsOptions()
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
    }
    
    private func buildSettingsOptions() -> [Option] {
        return [Option(title: "Name: \(dataset.name!)", segueName: nil),
                Option(title: "Labels", segueName: "labelsSegue"),
                Option(title: "Image size", segueName: nil),
                Option(title: "Model", segueName: nil)]
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let labelsVC = segue.destination as? LabelsVC {
            labelsVC.dataset = dataset
        }
    }
}

extension SettingsVC : UITableViewDataSource, UITableViewDelegate {
    
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].title
        if options[indexPath.row].segueName != nil {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    // When user taps on an option then show detail view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segueName = options[indexPath.row].segueName {
            performSegue(withIdentifier: segueName, sender: self)
        }
    }
}

