//
//  SelectDatasetVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 14/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class SelectDatasetVCTests: XCTestCase {
    
    var selectDatasetVC: SelectDatasetVC!
    
    override func setUp() {
        super.setUp()
        selectDatasetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectDatasetId") as! SelectDatasetVC
        selectDatasetVC.loadViewIfNeeded()
    }
    
    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(selectDatasetVC.datasetsTableView)
    }
}
