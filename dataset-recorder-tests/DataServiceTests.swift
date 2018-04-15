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
    
    // Count number of files in document directory
    private func countDocumentFiles() -> Int {
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return files.count
        } catch {
            XCTFail("Exception error")
            return 0
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
    func testNewIsRecent() {
        let dataset = DataService.instance.addDataset(withName: "Test")
        let expectation = XCTestExpectation(description: "Recent dataset")
        DataService.instance.recentDataset { (recentDataset) in
            XCTAssertEqual(dataset, recentDataset)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    // Touched dataset should be returned as recent
    func testDatasetTouch() {
        let dataset1 = DataService.instance.addDataset(withName: "Test 1")
        let _ = DataService.instance.addDataset(withName: "Test 2")
        dataset1.touch()
        let expectation = XCTestExpectation(description: "Recent dataset")
        DataService.instance.recentDataset { (dataset) in
            XCTAssertEqual(dataset, dataset1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    // Get labels
    func testDatasetLabels() {
        let dataset = DataService.instance.addDataset(withName: "Test 1")
        let _ = dataset.newLabel(name: "Label 1")
        XCTAssertEqual(dataset.getLabels().count, 1)
    }
    
    // Test add remove label
    func testAddRemoveLabels() {
        let dataset = DataService.instance.addDataset(withName: "Test 1")
        let labelCount = dataset.getLabels().count
        let label = dataset.newLabel(name: "test1")!
        XCTAssertEqual(dataset.getLabels().count, labelCount+1)
        dataset.delete(label: label)
        XCTAssertEqual(dataset.getLabels().count, labelCount)
    }
    
    // Test items management
    func testAddRemoveItems() {
        let dataset = DataService.instance.addDataset(withName: "Test 1")
        let itemCount = dataset.getItems().count
        let image = UIImage(named: "labels-icon")!
        let dataItem = dataset.newImageItem(image: image, withLabel: "test1")!
        XCTAssertEqual(dataset.getItems().count, itemCount+1)
        dataset.delete(item: dataItem)
        XCTAssertEqual(dataset.getItems().count, itemCount)
    }

    // When DataItem is removed its file should also be removed.
    func testRemoveItemFile() {
        let dataset = DataService.instance.addDataset(withName: "Test 1")
        let countFiles = countDocumentFiles()
        let image = UIImage(named: "labels-icon")!
        let dataItem = dataset.newImageItem(image: image, withLabel: "test1")!
        XCTAssertEqual(countDocumentFiles(), countFiles+1)
        dataset.delete(item: dataItem)
        XCTAssertEqual(countDocumentFiles(), countFiles)
    }
    
}
