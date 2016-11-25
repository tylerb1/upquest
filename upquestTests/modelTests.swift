//
//  modelTests.swift
//  upquest
//
//  Created by Matt on 11/23/16.
//  Copyright © 2016 UpQuest. All rights reserved.
//

import XCTest
@testable import upquest

class modelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testCreateTeacher(){
        let model = DatabaseModel(id: "1")
        model.createTeacher(lastName: "Smith", firstName: "Jane")
        let result = model.getAllTeachers()
        print(result.count)
        print(result[0].firstName!)
        print(result[0].lastName!)
        XCTAssert(true)
    }
    
}
