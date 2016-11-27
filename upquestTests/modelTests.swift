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
    
    var model = DatabaseModel(teacherID:"1")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        model.removeAll()
        model = DatabaseModel(teacherID:"1")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    private func createTestData(){
        let teacher = model.createTeacher(lastName: "Smith", firstName: "Jane", id: "1")
        let student = model.createStudent(lastName: "Jackson", firstName: "Betty")
        let course = model.createCourse(title: "Algebra", teacher: teacher!, students: [student!])
        let question = model.createQuestion(text: "What is the angle at x?",
                                            imageURL: "", explanation: "",
                                            answers: ["5","10","15","20"], correct: 3, tags : [])
        let quiz = model.createQuiz(name: "Angles", questions: [question!])
        let assignment = model.createAssignment(quiz: quiz!, course: course!)
        model.setAssignment(assignment: assignment!, assigned: true, dueDate: NSDate.init())
        let directory = model.createDirectory(title: "allQuizzes")
        model.addQuizToDirectory(quiz: quiz!, directory: directory!)
    }
    
    func testInit(){
        let result = model.getAllTeachers()
        XCTAssert(result.count == 1)
        XCTAssert(result[0].lastName == "Sandberg")
        XCTAssert(result[0].firstName == "Sheryl")
    }
    
    func testGetDirectoryStructure(){
        
    }
    
    func testCreateAssignment(){
        
    }
    
    func testRemoveAssignment(){
        
    }
    
    func testGetAssignments(){
        
    }
    
    func testSetAssignment(){
        
    }
    
    func testQueryQuizRepository(){
        
    }
    
    func testCreateDirectory(){
        
    }
    
    func testAddQuizToDirectory(){
        
    }
    
    func testRemoveQuizFromDirectory(){
        
    }
    
    func testGetStudents(){
        let teacherA = model.getTeacherUser()
        let teacherB = (model.createTeacher(lastName: "Smith", firstName: "Jane", id: "2"))!
        let studentA = (model.createStudent(lastName: "Jackson", firstName: "Betty"))!
        let studentB = (model.createStudent(lastName: "Jordan", firstName: "Michael"))!
        let studentC = (model.createStudent(lastName: "Jobs", firstName: "Steve"))!
        let courseA = model.createCourse(title: "Algebra", teacher: teacherA, students: [studentA])
        _ = model.createCourse(title: "English", teacher: teacherA, students: [studentB])
        _ = model.createCourse(title: "History", teacher: teacherB, students: [studentC])
        let result = model.getStudents(course: courseA!)
        XCTAssert(result.count == 1)
        XCTAssert(result[0].lastName == "Jackson")
        XCTAssert(result[0].firstName == "Betty")
    }

    func testCreateQuestion(){
        
    }
    
    func testCreateQuiz(){
        
    }

    func testGetCourses(){
        let teacherA = model.getTeacherUser()
        let teacherB = (model.createTeacher(lastName: "Smith", firstName: "Jane", id: "2"))!
        let student = (model.createStudent(lastName: "Jackson", firstName: "Betty"))!
        _ = model.createCourse(title: "Algebra", teacher: teacherA, students: [student])
        _ = model.createCourse(title: "English", teacher: teacherA, students: [student])
        _ = model.createCourse(title: "History", teacher: teacherB, students: [student])
        let result = model.getCourses()
        XCTAssert(result.count == 2)
        XCTAssert(result[0].title == "Algebra")
        XCTAssert(result[1].title == "English")
    }
    
    func testGetAnswers(){
        
    }
    
    func testGetClassScoresByQuiz(){
        
    }
    
    func testGetClassScoresByTag(){
        
    }
    

    
    func testRemoveAll(){
        createTestData()
        model.removeAll()
        XCTAssert(model.getAllTeachers().count == 0)
    }
    
    func testCreateTeacher(){
        model.removeAll()
        let teacher = model.createTeacher(lastName: "Smith", firstName: "Jane", id:"1")
        XCTAssert(teacher?.lastName == "Smith")
        XCTAssert(teacher?.firstName == "Jane")
        
        let result = model.getAllTeachers()
        XCTAssert(result.count == 1)
        XCTAssert(result[0].firstName! == "Jane")
        XCTAssert(result[0].lastName! == "Smith")
    }
    
    func testCreateCourse(){
        model.removeAll()
        let teacher = model.createTeacher(lastName: "Smith", firstName: "Jane", id: "1")
        let student = model.createStudent(lastName: "Jackson", firstName: "Betty")
        _ = model.createCourse(title: "Algebra", teacher: teacher!, students: [student!])
        _ = model.createCourse(title: "English", teacher: teacher!, students: [student!])
        let result = model.getAllCourses()
        XCTAssert(result.count == 2)
        XCTAssert(result[0].title == "Algebra")
        XCTAssert(result[1].title == "English")
    }
    
    func testCreateStudent(){
        let student = model.createStudent(lastName: "Jackson", firstName: "Betty")
        XCTAssert(student?.lastName == "Jackson")
        XCTAssert(student?.firstName == "Betty")
        
        let result = model.getAllStudents()
        XCTAssert(result.count == 1)
        XCTAssert(result[0].lastName == "Jackson")
        XCTAssert(result[0].firstName == "Betty")
    }
    
    func testLanguage(){
        var arr = Array(repeating: Array(repeating:0, count:10), count: 10)
        arr[0][0] = 1
        arr[1][1] = 2
        print(arr)
    }
    

}
