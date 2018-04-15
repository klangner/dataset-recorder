//
//  CameraVCTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 14/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
@testable import dataset_recorder


class CameraVCTests: XCTestCase {
    
    var cameraVC: CameraVC!
    
    override func setUp() {
        super.setUp()
        cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraId") as! CameraVC
        cameraVC.loadViewIfNeeded()
    }
    
    // Check outlets
    func testOutlets() {
        XCTAssertNotNil(cameraVC.cameraView)
        XCTAssertNotNil(cameraVC.flashButton)
    }
}
