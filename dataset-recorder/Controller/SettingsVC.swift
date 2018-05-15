//
//  SettingsVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 22/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

struct Option {
    let iconName: String?
    let title: String
    let segueName: String?
}

class SettingsVC: UIViewController {

    var dataset: Dataset!
    // List of options presented as a settings
    var options: [[Option]] = []
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.recentDataset { (dataset) in
            self.dataset = dataset
        }
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        options = buildSettingsOptions()
        settingsTableView.reloadData()
    }
    
    private func buildSettingsOptions() -> [[Option]] {
        let imageSize = dataset.imageSize ?? ImageSize.square480.rawValue
        return [[Option(iconName: "camera-icon", title: "\(dataset.name!)", segueName: nil)],
                [Option(iconName: nil, title: "Labels", segueName: "labelsSegue"),
                 Option(iconName: nil, title: "Image size: \(imageSize)", segueName: "imageSizeSegue"),
                 Option(iconName: nil, title: "Model", segueName: nil)]]
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LabelsVC {
            vc.dataset = dataset
        }
        else if let vc = segue.destination as? ImageSizeVC {
            vc.dataset = dataset
        }
    }
}

extension SettingsVC : UITableViewDataSource, UITableViewDelegate {
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    // Number of items in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            return 10.0
        }
    }
    
    // Show item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let option = options[indexPath.section][indexPath.row]
        if let iconName = option.iconName {
            cell.imageView?.image = UIImage(named: iconName)
        }
        cell.textLabel?.text = option.title
        if option.segueName != nil {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    // When user taps on an option then show detail view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.section][indexPath.row]
        if let segueName = option.segueName {
            performSegue(withIdentifier: segueName, sender: self)
        }
    }
}

