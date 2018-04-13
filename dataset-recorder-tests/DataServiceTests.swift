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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Even if the list of datasets is empty we should get recent default recent dataset
    func testNoDatasets() {
        // Dataset list is empty
        // Get recent dataset
    }
    
    // New added dataset should be returned as recent Dataset
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
