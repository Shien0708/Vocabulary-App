//
//  SpellingTestViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/1.
//

import UIKit

class SpellingTestViewController: UIViewController {
    var questions: [Spelling]!
    var isShowAnswer = true
    var isShowDashes = true
    var currentQuestionIndex = 0
    var timer: Timer?
    var correctCounts = 0
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var dashesLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
    }
    
    func setTimer(seconds: Int) {
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.timerLabel.text = "\(seconds-second)"
            if second >= seconds {
                self.pauseAnswering()
                self.changeColor()
                if self.isShowAnswer {
                    self.dashesLabel.text = self.questions[self.currentQuestionIndex].answer
                }
            }
            second += 1
        })
    }
    
    func showQuestion() {
        inputTextField.becomeFirstResponder()
        if questions[currentQuestionIndex].time != 0 {
            setTimer(seconds: questions[currentQuestionIndex].time)
        } else {
            timerLabel.isHidden = true
        }
        numLabel.text = "\(currentQuestionIndex+1)/\(questions.count)"
        questionLabel.text = questions[currentQuestionIndex].question
        inputTextField.text = ""
        inputTextField.backgroundColor = .white
        if isShowDashes {
            dashesLabel = questions[currentQuestionIndex].makeDashes(dash: dashesLabel)
        } else {
            dashesLabel.text = ""
        }
    }
    
    @IBAction func next(_ sender: Any) {
        nextButton.isHidden = true
        pauseView.isHidden = true
        currentQuestionIndex += 1
        showQuestion()
    }
    
    func showResult() {
        resultLabel.isHidden = false
        resultLabel.text = "對 \(correctCounts) 題、錯  \(questions.count-correctCounts) 題"
    }
    
    func pauseAnswering() {
        timer?.invalidate()
        
        if currentQuestionIndex == questions[currentQuestionIndex].questionCounts-1 {
            backButton.isHidden = false
            showResult()
        } else {
            nextButton.isHidden = false
        }
        pauseView.isHidden = false
    }
    
    func changeColor() {
        if questions[currentQuestionIndex].checkAnswer(ansToQues: questions[currentQuestionIndex].answer, inputAnswer: inputTextField.text!) {
            inputTextField.backgroundColor = .green
            correctCounts += 1
        } else {
            inputTextField.backgroundColor = .red
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        view.endEditing(true)
        pauseAnswering()
        changeColor()
        if isShowAnswer {
            dashesLabel.text = questions[currentQuestionIndex].answer
        }
        
    }
}

extension SpellingTestViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
