//
//  ExtensionTests.swift
//  dataset-recorder-tests
//
//  Created by Krzysztof Langner on 13/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import XCTest
import Foundation
@testable import dataset_recorder


class ExtensionTests: XCTestCase {
    
    func testClearTempDirectory() {
        do {
            let fileManager = FileManager.default
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.txt")
            try "text".write(to: fileURL, atomically: false, encoding: .utf8)
            let tmpDirectoryBefore = try fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            XCTAssertTrue(tmpDirectoryBefore.count > 0)
            fileManager.clearTmpDirectory()
            let tmpDirectoryAfter = try fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            XCTAssertEqual(tmpDirectoryAfter.count, 0)            
        } catch {
            XCTFail("Exception error")
        }
    }
}
