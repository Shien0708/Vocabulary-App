//
//  ChooseEditViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/1.
//

import UIKit

class ChooseEditViewController: UIViewController {
    @IBOutlet weak var questionCountsButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    var vocs = VocabularyList()
    var questions = [Choose]()
    var time = 0
    var questionCounts = 5
    
    var actions = [UIAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTimeOptions(button: timerButton)
        showQuestionCountsOptions(button: questionCountsButton)
    }
    
    @IBAction func makeChineseQuestions(_ sender: Any) {
        questions.removeAll()
        for _ in 0...questionCounts-1 {
            vocs.fetchAllVoc(with: vocs.letters[Int.random(in: 0...vocs.letters.count-1)] )
            vocs.storeDetails(use: vocs.allVoc)
            let answerIndex = Int.random(in: 0...vocs.chinese.count-1)
            var currentQuestions = [vocs.english[answerIndex]]
            for _ in 0...2 {
                var index = Int.random(in: 0...vocs.english.count-1)
                while index == answerIndex {
                    index = Int.random(in: 0...vocs.english.count-1)
                }
                currentQuestions.append(vocs.english[index])
            }
            
            questions.append(Choose(time: time, questionCounts: questionCounts, question: vocs.chinese[answerIndex], options: currentQuestions.shuffled(), answer: vocs.english[answerIndex]))
        }
        performSegue(withIdentifier: "showChoosingTest", sender: nil)
    }
    
    @IBAction func makeEnglishQuestions(_ sender: Any) {
        questions.removeAll()
        for _ in 0...questionCounts-1 {
            vocs.fetchAllVoc(with: vocs.letters[Int.random(in: 0...vocs.letters.count-1)] )
            vocs.storeDetails(use: vocs.allVoc)
            let answerIndex = Int.random(in: 0...vocs.chinese.count-1)
            var currentQuestions = [vocs.chinese[answerIndex]]
            for _ in 0...2 {
                var index = Int.random(in: 0...vocs.chinese.count-1)
                while index == answerIndex {
                    index = Int.random(in: 0...vocs.chinese.count-1)
                }
                currentQuestions.append(vocs.chinese[index])
            }
            
            questions.append(Choose(time: time, questionCounts: questionCounts, question: vocs.english[answerIndex], options: currentQuestions.shuffled(), answer: vocs.chinese[answerIndex]))
        }
        
        performSegue(withIdentifier: "showChoosingTest", sender: nil)
    }
    
    @IBSegueAction func showChoosingTest(_ coder: NSCoder) -> ChoosingTestViewController? {
        let controller = ChoosingTestViewController(coder: coder)
        controller?.questions = questions
        return controller
    }
    
    @IBAction func quitChossingTest(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func finishTest(_ segue: UIStoryboardSegue) {
    }
    // MARK: - Navigation
    
    
}

extension ChooseEditViewController {
    func showTimeOptions(button: UIButton) {
        let times = [0, 5, 10, 15, 20]
        button.showsMenuAsPrimaryAction = true
        actions.removeAll()
        for time in times {
            actions.append(UIAction(title: "\(time) 秒", handler: { _ in
                self.time = time
            }))
        }
        button.menu = UIMenu(children: actions)
    }
    
    func showQuestionCountsOptions(button: UIButton) {
        let counts = [5, 10, 15, 20, 25, 30]
        button.showsMenuAsPrimaryAction = true
        actions.removeAll()
        for count in counts {
            actions.append(UIAction(title: "\(count) 題", handler: {_ in
                self.questionCounts = count
            }))
        }
        button.menu = UIMenu(children: actions)
    }
    
    
}
