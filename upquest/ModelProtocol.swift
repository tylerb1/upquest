//
//  ModelProtocol.swift
//  upquest
//
//  Created by Tyler Berbert on 11/18/16.
//  Copyright © 2016 UpQuest. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol Tag {
    var tagText: String {get}
}

protocol AnswerChoice {
    var isCorrect: Bool {get}
    var answerText: String {get}
}

protocol Question {
    var answerChoices: [AnswerChoice] {get}
    var correctAnswer: AnswerChoice {get}
    var imageURL: String {get}
    var tags: [Tag] {get}
    var difficulty: String {get}
    var popularity: Int {get}
}

protocol Student {
    var name: String {get}
    var assignedQuizzes: [Quiz] {get}
    var answersChosen: [Int: [AnswerChoice]] {get}
}

protocol Teacher {
    var name: String {get}
    var directories: [Directory] {get}
    var classes: [Class] {get}
}

protocol Class {
    var studentList: [Student] {get}
    var semester: String {get}
    var quizList: [Quiz] {get}
    var latestQuiz: Quiz {get}
}

protocol Quiz {
    var name: String {get}
    var dueDate: String {get}
    var isAssigned: Bool {get}
    var questionList: [Question] {get}
    var studentsAssigned: [Student] {get}
}

protocol Directory {
    var name: String {get}
    var quizzes: [Quiz] {get}
}
