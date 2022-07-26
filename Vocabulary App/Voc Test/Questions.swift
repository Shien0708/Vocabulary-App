//
//  Questions.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/1.
//

import Foundation
import UIKit


struct Choose {
    var time: Int
    var questionCounts: Int
    var question: String
    var options: [String]
    var answer: String
    var correctCounts = 0
    var wrongCounts = 0
    
    mutating func checkChoosing(answer: String, chosenAnswer: String) -> Bool {
        if answer != chosenAnswer {
            wrongCounts += 1
            return false
        } else {
            correctCounts += 1
            return true
        }
    }
}


struct Spelling {
    var question: String
    var answer: String
    var letterCounts: Int
    var time: Int
    var questionCounts: Int
    
    mutating func checkAnswer(ansToQues: String, inputAnswer: String) -> Bool {
        if ansToQues == inputAnswer {
            return true
        } else {
            return false
        }
    }
    
    func makeDashes(dash: UILabel) -> UILabel {
        dash.text = ""
        for _ in 1...letterCounts {
            dash.text! += " _"
        }
        return dash
    }
}
