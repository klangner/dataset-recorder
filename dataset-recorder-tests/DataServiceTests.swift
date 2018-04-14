//
//  DataServiceTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 13/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class DataServiceTests: XCTestCase {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Helper function which removes all datasets
    private func removeAllDatasets(completion: () -> ()) {
        DataService.instance.fetchDatasets { (datasets) in
            for dataset in datasets {
                DataService.instance.remove(dataset: dataset)
            }
            completion()
        }
    }

    // Even if the list of datasets is empty we should get recent default recent dataset
    func testNoDatasets() {
        let datasetRemovedExpectation = XCTestExpectation(description: "Remove all datasets")
        removeAllDatasets {
            datasetRemovedExpectation.fulfill()
        }
        wait(for: [datasetRemovedExpectation], timeout: 10.0)
        
        // Get recent dataset
        let recentDatasetExpectation = XCTestExpectation(description: "We should get recent dataset")
        DataService.instance.recentDataset { (dataset) in
            recentDatasetExpectation.fulfill()
        }
        wait(for: [recentDatasetExpectation], timeout: 10.0)
    }
    
    // New added dataset should be returned as recent Dataset
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
