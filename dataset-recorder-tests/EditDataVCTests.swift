//
//  EditDataVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 15/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class EditDataVCTests: XCTestCase {
    
    var editDataVC: EditDataVC!
    var dataItem: DataItem!
    
    override func setUp() {
        super.setUp()
        DataService.instance.recentDataset { (dataset) in
            let image = UIImage(named: "labels-icon")!
            dataItem = dataset.newImageItem(image: image, withLabel: "test1")
            editDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editDataVC") as! EditDataVC
            editDataVC.dataItem = dataItem
            editDataVC.loadViewIfNeeded()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        dataItem.dataset!.delete(item: dataItem)
    }

    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(editDataVC.imageView)
        XCTAssertNotNil(editDataVC.dataLabel)
    }
}
