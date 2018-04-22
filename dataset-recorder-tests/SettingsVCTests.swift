//
//  SettingsVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 22/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class SettingsVCTests: XCTestCase {
    
    var settingsVC: SettingsVC!
    
    override func setUp() {
        super.setUp()
        settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as! SettingsVC
        settingsVC.loadViewIfNeeded()
    }
    
    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(settingsVC.settingsTableView)
        XCTAssertNotNil(settingsVC.datasetNameLabel)
    }
    
    // Set dataset name label
    func testShowDatasetName() {
        XCTAssertEqual(settingsVC.dataset.name, settingsVC.datasetNameLabel.title)
    }
}
