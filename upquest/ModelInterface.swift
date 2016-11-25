//
//  ModelUpdater.swift
//  upquest
//
//  Created by Matt on 11/16/16.
//  Copyright © 2016 UpQuest. All rights reserved.
//

import Foundation

protocol ModelInterface{
    
    // Task 1 : Manage Quizzes
    
    /// Returns a list of directories for the quiz library of the given teacher.
    ///
    /// - Returns: list of directory objects
    func getDirectoryStructure() -> Array<Directory>
    
    /// Places quiz in class management folder to be assigned
    ///
    /// - Parameters:
    ///   - quiz: NSObject quiz instance
    ///   - course: NSObject course instance
    /// - Returns: Optional NSObject Assignment created and saved
    func createAssignment(quiz : Quiz, course : Course) -> Assignment?
    
    /// Removes the quiz from the class management folder
    ///
    /// - Parameter assignment: NSObject representing assignment
    /// - Returns: Void
    func removeAssignment(assignment : Assignment)
    
    /// Returns all assignments associated with a given course
    ///
    /// - Parameter course: NSObject Course target
    /// - Returns: List of NSObject Assignment associated with target course
    func getAssignments(course : Course) -> Array<Assignment>
    
    /// Modifies the assign and due date status of a given assignment
    ///
    /// - Parameters:
    ///   - assignment: NSObject Assignment target
    ///   - assigned: Bool representing assigned status
    ///   - dueDate: NSDate Object representing last date to hand in
    /// - Returns: Void
    func setAssignment(assignment : Assignment, assigned : Bool, dueDate : NSDate)
    
    // Task 2 : Create new quizzes
    
    /// Search bar functionality which returns array of quizzes with relevant results.
    ///
    /// - Parameter queryText: String text from search bar
    /// - Returns: List of NSObject Quiz representing search results
    func queryQuizRepository(queryText : String) -> Array<Quiz>
    
    /// Create a new directory and saves it to database.
    ///
    /// - Parameter title: String name of directory
    /// - Returns: Optional NSObject of new directory structure
    func createDirectory(title : String) -> Directory?
    
    /// Add a quiz to a given directory for organization.
    ///
    /// - Parameters:
    ///   - quiz: NSObject Quiz target
    ///   - directory: NSObject Directory to place quiz in
    /// - Returns: Void
    func addQuizToDirectory(quiz : Quiz, directory : Directory)
    
    /// Remove quiz from a given directory.
    ///
    /// - Parameters:
    ///   - quiz: NSObject Quiz target
    ///   - directory: NSObject Directory to remove quiz from
    /// - Returns: void
    func removeQuizFromDirectory(quiz : Quiz, directory : Directory)
    
    /// Returns list of student for a given course.
    ///
    /// - Parameter course: NSObject Course target
    /// - Returns: List of NSObject Student os associated course
    func getStudents(course : Course) -> Array<Student>
    
    /// Creates a new question and saves it to database.
    ///
    /// - Parameters:
    ///   - text: String text of question
    ///   - imageURL: String image url
    ///   - explanation: String explanation of answer
    ///   - answers: List of String denoting possible answers
    ///   - correct: Int of index corresponding to correct answer in answers list
    /// - Returns: Optional NSObject Question saved to database
    func createQuestion(text : String, imageURL : String, explanation : String,
                        answers : Array<String>, correct : Int) -> Question?
    
    /// Creates a quiz and saves it to database.
    ///
    /// - Parameters:
    ///   - name: String name of quiz
    ///   - questions: List of NSObject Question content of quiz
    /// - Returns: Optional NSObject Quiz saved to database
    func createQuiz(name : String, questions : Array<Question>) -> Quiz?
    
    // Task 3 : Visualize quiz results
    
    /// Returns all courses associated with given teacher.
    ///
    /// - Returns: List of NSObject Course for given teacher
    func getCourses() -> Array<Course>
    
    /// Return indicies of chosen answers for student quiz combination.
    ///
    /// - Parameters:
    ///   - student: NSObject Student of target student
    ///   - quiz: NSObject Quiz of target Quiz
    /// - Returns: List of indices of chosen answers for each question in quiz
    func getAnswers(student : Student, quiz : Quiz) -> Array<Int>
    
    /// Returns quiz scores to populate matrix view.
    ///
    /// - Parameter course: NSObject Course target
    /// - Returns: (List of NSObject Student, List of NSObject Quiz, matrix of quiz scores)
    func getClassScoresByQuiz(course : Course) -> (Array<Student>, Array<Quiz>, Array<Array<Double>>)
    
    /// Returns scores by tag across all quizzes in a given course.
    ///
    /// - Parameter course: NSObject Course target
    /// - Returns: (List of NSObject Tag, List of score for associated tag)
    func getClassScoresByTag(course : Course) -> (Array<Tag>, Array<Double>)


}
