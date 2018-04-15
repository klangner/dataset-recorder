//
//  DatasetVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 14/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class DatasetVCTests: XCTestCase {
    
    var datasetVC: DatasetVC!

    override func setUp() {
        super.setUp()
        datasetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "datasetImagesId") as! DatasetVC
        datasetVC.loadViewIfNeeded()
    }
    
    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(datasetVC.currentDatasetLabel)
        XCTAssertNotNil(datasetVC.dataCollectionView)
    }
}
