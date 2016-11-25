//
//  databaseModel.swift
//  upquest
//
//  Created by Matt on 11/24/16.
//  Copyright © 2016 UpQuest. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseModel : ModelInterface{
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var teacherID = ""
    
    init(id : String){
        teacherID = id
    }
    
    // Fill database with a few examples to test functions
    func createTestData(){
        
    }
    
    // Task 1 : Manage Quizzes
    
    func getDirectoryStructure() -> Array<Directory>{
        let fetchRequest : NSFetchRequest<Directory> = Directory.fetchRequest()
        fetchRequest.predicate = NSPredicate()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    

    func createAssignment(quiz : Quiz, course : Course) -> Assignment? {
        if let assignment = NSEntityDescription.insertNewObject(forEntityName: "Assignment", into: moc) as? Assignment {
            assignment.assigned = false
            assignment.dueDate = nil
            try? moc.save()
            return assignment
        }
        return nil
    }
    
    func removeAssignment(assignment : Assignment){
        moc.delete(assignment)
        try? moc.save()
    }
    
    func getAssignments(course : Course) -> Array<Assignment>{
        let fetchRequest : NSFetchRequest<Assignment> = Assignment.fetchRequest()
        fetchRequest.predicate = NSPredicate()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func setAssignment(assignment : Assignment, assigned : Bool, dueDate : NSDate){
        assignment.assigned = assigned
        assignment.dueDate = dueDate
        try? moc.save()
    }
    
    // Task 2 : Create new quizzes
    func queryQuizRepository(queryText : String) -> Array<Quiz>{
        // TODO : Not yet implemented
        return []
    }
    
    func createDirectory(title : String) -> Directory? {
        if let directory = NSEntityDescription.insertNewObject(forEntityName: "Directory", into: moc) as? Directory {
            directory.title = title
            try? moc.save()
            return directory
        }
        return nil
    }
    
    func addQuizToDirectory(quiz : Quiz, directory : Directory){
        quiz.addToDirectories(directory)
        try? moc.save()
    }
    
    func removeQuizFromDirectory(quiz : Quiz, directory : Directory){
        quiz.removeFromDirectories(directory)
        try? moc.save()
    }
    
    func getStudents(course : Course) -> Array<Student>{
        let fetchRequest : NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func createQuestion(text : String, imageURL : String, explanation : String,
                        answers : Array<String>, correct : Int) -> Question? {
        assert(correct < answers.count)
        // Save answer choices
        var isCorrect = false
        var answerObjects : Array<AnswerChoice> = []
        for (index, answer) in answers.enumerated(){
            if index == correct{
                isCorrect = false
            }else{
                isCorrect = true
            }
            if let choice = NSEntityDescription.insertNewObject(forEntityName: "answerChoice", into: moc) as? AnswerChoice {
                choice.text = answer
                choice.isCorrect = isCorrect
                answerObjects.append(choice)
            }
        }
        // Save question with associated answer choices
        if let question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: moc) as? Question {
            question.text = text
            question.explanation = explanation
            for object in answerObjects{
                question.addToAnswerChoices(object)
            }
            try? moc.save()
            return question
        }
        return nil
    }
    
    func createQuiz(name : String, questions : Array<Question>) -> Quiz? {
        if let quiz = NSEntityDescription.insertNewObject(forEntityName: "Quiz", into: moc) as? Quiz {
            quiz.name = name
            for question in questions{
                quiz.addToQuestions(question)
            }
            try? moc.save()
            return quiz
        }
        return nil
    }

    
    // Task 3 : Visualize quiz results
    func getCourses() -> Array<Course>{
        let fetchRequest : NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func getAnswers(student : Student, quiz : Quiz) -> Array<Int>{
        return []
    }
    
    func getClassScoresByQuiz(course : Course) -> (Array<Student>, Array<Quiz>, Array<Array<Double>>){
        return ([],[],[[]])
    }
    
    func getClassScoresByTag(course : Course) -> (Array<Tag>, Array<Double>){
        return ([],[])
    }
    
    
    // Helper functions to initialize some data in the database
    
    func createTeacher(lastName : String, firstName : String) -> Teacher?{
        if let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: moc) as? Teacher {
            teacher.lastName = lastName
            teacher.firstName = firstName
            try? moc.save()
            return teacher
        }
        return nil
    }
    
    func getAllTeachers() -> Array<Teacher>{
        let request : NSFetchRequest<Teacher> = Teacher.fetchRequest()
        //request.predicate = NSPredicate()
        let teachers = try? moc.fetch(request)
        return teachers!
    }
    
    /**
     Clears database of all persistent stored objects
    */
    func removeAll(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
        do{
            let results = try? moc.fetch(request)
            for managedObject in results!
            {
                let managedObjectData = managedObject as! NSManagedObject
                moc.delete(managedObjectData)
            }
        }
    }
    
    func createStudent(lastName : String, firstName : String) -> Student?{
        if let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: moc) as? Student {
            student.lastName = lastName
            student.firstName = firstName
            try? moc.save()
            return student
        }
        return nil
    }
     
    func createCourse(title : String, teacher : Teacher, students : Array<Student>) -> Course?{
        if let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: moc) as? Course {
            course.title = title
            course.teacher = teacher
            for student in students{
                course.addToStudents(student)
            }
            try? moc.save()
            return course
        }
        return nil
    }
     

     
}
