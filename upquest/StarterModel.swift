//
//  starterModel.swift
//  upquest
//
//  Created by Matt on 11/23/16.
//  Copyright © 2016 UpQuest. All rights reserved.
//

import Foundation

// Simple implementation of model backend that just provides
// fixed outputs for getter functions and does nothing for setters
// TODO : Not yet implemented

class StarterModel : ModelInterface{
    
    // Task 1 : Manage Quizzes
    func getDirectoryStructure() -> Array<Directory>{
        return []
    }
    
    func addQuizToClass(quizID : String, classID : String){
        
    }
    
    func removeQuizFromClass(quizID : String, classID : String){
        
    }
    
    // Task 2 : Create new quizzes
    func getQuiz(quizID : String) -> Quiz{
        return Quiz()
    }
    
    func queryQuizRepository(queryText : String) -> Array<Quiz>{
        return []
    }
    
    func addQuizToDirectory(quizID : String){
        
    }
    
    func removeQuizFromDirectory(quizID : String, directoryID : String){
        
    }
    
    func getQuestion(questionID : String) -> Array<Question>{
        return []
    }
    
    func getStudents(classID : String) -> Array<Student>{
        return []
    }
    
    // Task 3 : Visualize quiz results
    func getClasses() -> Array<Class>{
        return []
    }
    
    func getAnswers(studentID : String, quizID : String) -> Array<Int>{
        return []
    }
    
    func getClassScoresByQuiz(classID : String) -> (Array<Student>, Array<Quiz>, Array<Array<Double>>){
        return ([],[],[[]])
    }
    
    func getClassScoresByTag(classID : String) -> (Array<Tag>, Array<Double>){
        return ([],[])
    }
    
}
