//
//  ChoosingTestViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/1.
//

import UIKit

class ChoosingTestViewController: UIViewController {
    var questions: [Choose]!
    var vocs: VocabularyList!
    var currentQuestionIndex = 0
    var correctCounts = 0
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
        
    }
    
    func setTimer() {
        timerLabel.text = "\(questions[currentQuestionIndex].time)"
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if second >= self.questions[self.currentQuestionIndex].time {
                timer.invalidate()
                self.showNextButton()
                for button in self.answerButtons {
                    if self.questions[self.currentQuestionIndex].checkChoosing(answer: self.questions[self.currentQuestionIndex].answer, chosenAnswer: (button.titleLabel?.text)!) {
                        button.configuration?.baseBackgroundColor = .green
                    }
                }
            }
            self.timerLabel.text = "\(self.questions[self.currentQuestionIndex].time-second)"
            second += 1
        })
    }
    
    @IBAction func next(_ sender: Any) {
        nextButton.isHidden = true
        pauseView.isHidden = true
        currentQuestionIndex += 1
        showQuestion()
    }
    
    func showResult() {
        resultLabel.isHidden = false
        resultLabel.text = "對 \(correctCounts) 題、錯 \(questions.count-correctCounts) 題"
    }
    
    
    func showQuestion() {
        if questions[currentQuestionIndex].time != 0 {
            setTimer()
        } else {
            timerLabel.isHidden = true
        }
        for (i, button) in answerButtons.enumerated() {
            button.setTitle("\(questions[currentQuestionIndex].options[i])", for: .normal)
            button.configuration?.baseBackgroundColor = UIColor(red: 219/255, green: 226/255, blue: 239/255, alpha: 1)
        }
        
        questionLabel.text = questions[currentQuestionIndex].question
        numLabel.text = "\(currentQuestionIndex+1)/\(questions.count)"
    }
    
    
    func showNextButton() {
        if currentQuestionIndex == questions[currentQuestionIndex].questionCounts-1 {
            backButton.isHidden = false
            showResult()
        } else {
            nextButton.isHidden = false
        }
        pauseView.isHidden = false
    }

    @IBAction func chooseAnswer(_ sender: UIButton) {
        timer?.invalidate()
        showNextButton()
        if questions[currentQuestionIndex].checkChoosing(answer: questions[currentQuestionIndex].answer, chosenAnswer: (sender.titleLabel?.text)!) {
            sender.configuration?.baseBackgroundColor = .green
            correctCounts += 1
        } else {
            sender.configuration?.baseBackgroundColor = .red
            for button in answerButtons {
                if questions[currentQuestionIndex].checkChoosing(answer: questions[currentQuestionIndex].answer, chosenAnswer: (button.titleLabel?.text)!) {
                    button.configuration?.baseBackgroundColor = .green
                }
            }
        }
    }
    

}
