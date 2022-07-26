//
//  SpellingEditingViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/1.
//

import UIKit

class SpellingEditingViewController: UIViewController {
    var questions = [Spelling]()
    var actions = [UIAction]()
    let vocs = VocabularyList()
    var time = 0
    var questionCounts = 5
    
    @IBOutlet weak var questionCountsButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    
    var isShowAnswer = true
    var isShowDashes = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTimeButton(button: timeButton)
        showQuestionCountsButton(button: questionCountsButton)
    }
    
    
    @IBAction func showSpellingTest(_ sender: Any) {
        questions.removeAll()
        for _ in 0...questionCounts-1 {
            vocs.fetchAllVoc(with: vocs.letters[Int.random(in: 0...vocs.letters.count-1)])
            vocs.storeDetails(use: vocs.allVoc)
            let answerIndex = Int.random(in: 0...vocs.english.count-1)
            questions.append(Spelling(question: vocs.chinese[answerIndex], answer: vocs.english[answerIndex], letterCounts: vocs.english[answerIndex].count, time: time, questionCounts: questionCounts))
        }
        performSegue(withIdentifier: "showTest", sender: nil)
    }
    
    @IBSegueAction func showTest(_ coder: NSCoder) -> SpellingTestViewController? {
        let controller = SpellingTestViewController(coder: coder)
        controller?.isShowDashes = isShowDashes
        controller?.isShowAnswer = isShowAnswer
        controller?.questions = questions
        return controller
    }
    
    @IBAction func showAnswer(_ sender: UISwitch) {
        if sender.isOn {
            isShowAnswer = true
        } else {
            isShowAnswer = false
        }
    }
    
    @IBAction func showDashes(_ sender: UISwitch) {
        if sender.isOn {
            isShowDashes = true
        } else {
            isShowDashes = false
        }
    }
    
    @IBAction func quitSpellingTest(_ segue: UIStoryboardSegue) {
    }
    @IBAction func finish(_ segue: UIStoryboardSegue) {
    }
    
}


extension SpellingEditingViewController {
    func showTimeButton(button: UIButton) {
        let times = [0, 5, 10, 15, 20, 25, 30]
        actions.removeAll()
        button.showsMenuAsPrimaryAction = true
        for time in times {
            actions.append(UIAction(title: "\(time) 秒", handler: { _ in
                self.time = time
            }))
        }
        button.menu = UIMenu(children: actions)
    }
    
    func showQuestionCountsButton(button: UIButton) {
        actions.removeAll()
        let counts = [5, 10, 15, 20, 15, 30]
        for count in counts {
            actions.append(UIAction(title: "\(count) 題", handler: { _ in
                self.questionCounts = count
            }))
        }
        button.menu = UIMenu(children: actions)
    }
}
