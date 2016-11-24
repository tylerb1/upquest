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
    func getDirectoryStructure() -> Array<Directory>
    
    func addQuizToClass(quizID : String, classID : String)
    
    func removeQuizFromClass(quizID : String, classID : String)
    
    // Task 2 : Create new quizzes
    func getQuiz(quizID : String) -> Quiz
    
    func queryQuizRepository(queryText : String) -> Array<Quiz>
    
    func addQuizToDirectory(quizID : String)
    
    func removeQuizFromDirectory(quizID : String, directoryID : String)
    
    func getQuestion(questionID : String) -> Array<Question>
    
    func getStudents(classID : String) -> Array<Student>
    
    // Task 3 : Visualize quiz results
    func getClasses() -> Array<Class>
    
    func getAnswers(studentID : String, quizID : String) -> Array<Int>
    
    func getClassScoresByQuiz(classID : String) -> (Array<Student>, Array<Quiz>, Array<Array<Double>>)
    
    func getClassScoresByTag(classID : String) -> (Array<Tag>, Array<Double>)

}
