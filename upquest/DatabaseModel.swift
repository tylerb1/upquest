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
    var teacherUser : Teacher
    
    init(teacherID : String){
        // Create teacher instance in database if does not exist
        let fetchRequest : NSFetchRequest<Teacher> = Teacher.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", teacherID)
        let result = try? moc.fetch(fetchRequest)
        assert(result!.count <= 1)
        if result!.count == 1{
            teacherUser = result![0]
        }else{
            let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: moc) as? Teacher
            teacher?.lastName = "Sandberg"
            teacher?.firstName = "Sheryl"
            teacher?.id = teacherID
            try? moc.save()
            teacherUser = teacher!
        }
    }
    
    // Task 1 : Manage Quizzes
    
    func getDirectoryStructure() -> Array<Directory>{
        let fetchRequest : NSFetchRequest<Directory> = Directory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "teacher == %@", teacherUser)
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
        fetchRequest.predicate = NSPredicate(format: "course == %@", course)
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
        fetchRequest.predicate = NSPredicate(format: "ANY courses == %@", course)
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func getQuizzes(course : Course) -> Array<Quiz>{
        let fetchRequest : NSFetchRequest<Quiz> = Quiz.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY courses.course == %@", course)
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func createQuestion(text : String, imageURL : String, explanation : String,
                        answers : Array<String>, correct : Int, tags : Array<String>) -> Question? {
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
            if let choice = NSEntityDescription.insertNewObject(forEntityName: "AnswerChoice", into: moc) as? AnswerChoice {
                choice.text = answer
                choice.isCorrect = isCorrect
                answerObjects.append(choice)
            }
        }
        // Retrieve existing tag is exists in database - otherwise generate new tag instance
        var tagObjects : Array<Tag> = []
        for tagString in tags{
            let fetchRequest : NSFetchRequest<Tag> = Tag.fetchRequest()
            let result = try? moc.fetch(fetchRequest)
            assert(result!.count <= 1)
            if result!.count == 1{
                tagObjects.append(result![0])
            }else{
                let newTag = createTag(text: tagString)
                tagObjects.append(newTag!)
            }
        }
        
        // Save question with associated answer choices
        if let question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: moc) as? Question {
            question.text = text
            question.explanation = explanation
            for object in answerObjects{
                question.addToAnswerChoices(object)
            }
            for tag in tagObjects{
                question.addToTags(tag)
            }
            try? moc.save()
            return question
        }
        return nil
    }
    
    func createTag(text : String) -> Tag?{
        if let tag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: moc) as? Tag {
            tag.text = text
            return tag
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
        fetchRequest.predicate = NSPredicate(format:"teacher == %@", teacherUser)
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func getAnswers(student : Student, quiz : Quiz) -> Array<AnswerChoice>{
        let fetchRequest : NSFetchRequest<AnswerChoice> = AnswerChoice.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(studentAnswers.student) == %@ AND (studentAnswers.quiz == %@)", argumentArray: [student, quiz])
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    
    func getClassScoresByQuiz(course : Course) -> (Array<Student>, Array<Quiz>, Array<Array<Double>>){
        let students = getStudents(course: course)
        let quizzes = getQuizzes(course: course)
        var scores = Array(repeating: Array(repeating: 0.0, count:quizzes.count), count: students.count)
        for i in 0..<students.count{
            for j in 0..<quizzes.count{
                scores[i][j] = getQuizScore(student: students[i], quiz: quizzes[j])
            }
        }
        return (students, quizzes, scores)
    }
    
    func getQuizScore(student : Student, quiz : Quiz) -> Double{
        // Not yet implemented - currently returns a random double between 0.0 and 1.0
        return drand48()
    }
    
    func getClassScoresByTag(course : Course) -> (Array<Tag>, Array<Double>){
        let fetchRequest : NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"ANY questions.studentAnswers.quiz.courses.course == %@", course)
        let resultTags = (try? moc.fetch(fetchRequest))!
        let scores = Array(repeating: 0.0, count: resultTags.count)
        return (resultTags, scores)
    }
    
    func getTagScore(student: Student, tag : Tag) -> Double{
        // Not yet implemented - currently returns a random double between 0.0 and 1.0
        return drand48()
    }
    
    
    // Helper functions which are not in the protocol
    
    func createTeacher(lastName : String, firstName : String, id : String) -> Teacher?{
        if let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: moc) as? Teacher {
            teacher.lastName = lastName
            teacher.firstName = firstName
            teacher.id = id
            try? moc.save()
            return teacher
        }
        return nil
    }
    
    
    // Used for testing code
    func executeFetch(fetchRequest : NSFetchRequest<NSFetchRequestResult>) -> Array<Any>?{
        let result = try? moc.fetch(fetchRequest)
        return result
    }
    
    /**
     Clears database of all persistent stored objects
    */
    func removeAll(){
        let allEntities = ["Teacher","Course","Student","Quiz","Question",
                           "Assignment","Tag","AnswerChoice","StudentAnswer",
                           "Directory"]
        for entity in allEntities{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            request.returnsObjectsAsFaults = false
            do{
                let results = try? moc.fetch(request)
                for managedObject in results!{
                    let managedObjectData = managedObject as! NSManagedObject
                    moc.delete(managedObjectData)
                }
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

    // Testing and Debugging methods
    
    func getTeacherUser() -> Teacher{
        return teacherUser
    }
    
    func setTeacherUser(teacher : Teacher){
        teacherUser = teacher
    }
    
    // Getter methods for testing
    
    func getAllTeachers() -> Array<Teacher>{
        let fetchRequest : NSFetchRequest<Teacher> = Teacher.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllCourses() -> Array<Course>{
        let fetchRequest : NSFetchRequest<Course> = Course.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllStudents() -> Array<Student>{
        let fetchRequest : NSFetchRequest<Student> = Student.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllQuizzes() -> Array<Quiz>{
        let fetchRequest : NSFetchRequest<Quiz> = Quiz.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllQuestions() -> Array<Question>{
        let fetchRequest : NSFetchRequest<Question> = Question.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllAssignments() -> Array<Assignment>{
        let fetchRequest : NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllTags() -> Array<Tag>{
        let fetchRequest : NSFetchRequest<Tag> = Tag.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllAnswerChoices() -> Array<AnswerChoice>{
        let fetchRequest : NSFetchRequest<AnswerChoice> = AnswerChoice.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllStudentAnswers() -> Array<StudentAnswer>{
        let fetchRequest : NSFetchRequest<StudentAnswer> = StudentAnswer.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }
    func getAllDirectories() -> Array<Directory>{
        let fetchRequest : NSFetchRequest<Directory> = Directory.fetchRequest()
        let result = try? moc.fetch(fetchRequest)
        return result!
    }

     
}
