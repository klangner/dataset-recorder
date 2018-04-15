//
//  LabelsVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 15/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class LabelsVCTests: XCTestCase {
    
    var labelsVC: LabelsVC!
    
    override func setUp() {
        super.setUp()
        labelsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "labelsVC") as! LabelsVC
        labelsVC.loadViewIfNeeded()
    }
    
    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(labelsVC.labelTableView)
    }
}
