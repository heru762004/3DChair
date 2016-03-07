//
//  MyChairTests.swift
//  MyChairTests
//
//  Created by Cassis Dev on 5/3/16.
//  Copyright © 2016 heru. All rights reserved.
//

import XCTest
@testable import MyChair

class MyChairTests: XCTestCase {
    var obj:GameViewController?
    var expectation:XCTestExpectation!
    
    override func setUp() {
        obj = GameViewController()
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // add fire, water, kill fire, kill water
    func testFunctionality() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        obj?.addFire()
        let zeroValue:CGFloat = 0.0
        XCTAssertGreaterThan((obj?.fireBirthRate)!, zeroValue)
        XCTAssertEqual(obj?.chairShape.particleSystems?.count, 1)
        obj?.showRain()
        XCTAssertEqual(obj?.chairShape.particleSystems?.count, 2)
        obj?.killFire()
        XCTAssertEqual(obj?.chairShape.particleSystems?.count, 1)
        obj?.killRain()
        XCTAssertEqual(obj?.chairShape.particleSystems?.count, 0)
        
    }
    
    // test function handle tap
//    func testHandleTap() {
//        let tapGesture = UITapGestureRecognizer()
//        obj?.handleTap(tapGesture)
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
