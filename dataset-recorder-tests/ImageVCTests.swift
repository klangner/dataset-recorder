//
//  ImageVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 15/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class ImageVCTests: XCTestCase {
    
    var imageVC: ImageVC!
    
    override func setUp() {
        super.setUp()
        imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageVC") as! ImageVC
        imageVC.loadViewIfNeeded()
    }
    
    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(imageVC.imageView)
        XCTAssertNotNil(imageVC.labelsTableView)
    }
}
