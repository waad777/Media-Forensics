//
//  MediaForensicsTests.swift
//  MediaForensicsTests
//
//  Created by Waad Alkatheeri on 15/04/2020.
//  Copyright © 2020 Waad Alkatheeri. All rights reserved.
//

import XCTest
import SwiftChain

@testable import MediaForensics

class MediaForensicsTests: XCTestCase {
    
    let block = Blockchain()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        for hash in 1...1_000_000{
            block.addBlock(with: hash.description)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.block.checkValidity(with: "1_000_000")
        }
    }

}
