//
//  SpellingGameViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/5.
//

import UIKit

class SpellingGameViewController: UIViewController {
    var second: Double = 5
    var vocs = VocabularyList()
    var timer: Timer?
    var dropLevel = 0
    var answerString = ""
    var answerIndex = 0
    var correctCounts = 0
    
    
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var rockView: UIView!
    @IBOutlet weak var torchImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        torchImageView.image = UIImage.animatedImageNamed("torch-", duration: 1)
        moveRock()
        makeAQuestion()
    }
    
    
    func makeAQuestion() {
        answerButton.isEnabled = true
        vocs.fetchAllVoc(with: vocs.letters[Int.random(in: 0...vocs.letters.count-1)])
        vocs.storeDetails(use: vocs.allVoc)
        answerIndex = Int.random(in: 0...vocs.chinese.count-1)
        questionLabel.text = vocs.chinese[answerIndex]
        blockView.isHidden = true
        var letterCounts = 0
        for letter in vocs.english[answerIndex] {
            if letter != " " {
                letterCounts += 1
            }
        }
        hintLabel.text = "共 \(letterCounts) 個字母"
    }
    
    func moveRock() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(second), repeats: true, block: { timer in
            self.dropLevel += 1
            self.rockView.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.dropLevel*10))
            if self.rockView.frame.maxY > self.view.bounds.height/2 {
                self.emojiLabel.text = "😰"
            } else {
                self.emojiLabel.text = "🙂"
            }
            if self.rockView.frame.maxY >= self.emojiLabel.frame.minY+30 {
                self.emojiLabel.text = "💀"
                self.timer?.invalidate()
                self.blockView.isHidden = false
                self.againButton.isHidden = false
            }
        })
        
    }
    
    @IBAction func enter(_ sender: UIButton) {
        answerLabel.text! += (sender.configuration?.title)!
    }
    
    
    @IBAction func check(_ sender: UIButton) {
        blockView.isHidden = false
        sender.isEnabled = false
        timer?.invalidate()
        if answerLabel.text! == vocs.english[answerIndex] {
            emojiLabel.text = "😃"
            correctCounts += 1
            correctCountLabel.text = "答對 \(correctCounts) 題"
        } else {
            emojiLabel.text = "😟"
            answerLabel.text = vocs.english[answerIndex]
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
            self.moveRock()
            self.makeAQuestion()
            self.answerLabel.text = ""
        })
    }
    
    @IBAction func back(_ sender: Any) {
        if !answerLabel.text!.isEmpty {
            answerLabel.text?.removeLast()
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        answerLabel.text = ""
    }
    
    
    @IBAction func playAgain(_ sender: Any) {
        rockView.transform = CGAffineTransform.init(translationX: 0, y: CGFloat(-(dropLevel*10)))
        againButton.isHidden = true
        blockView.isHidden = true
        dropLevel = 0
        correctCounts = 0
        answerLabel.text = ""
        emojiLabel.text = "🙂"
        correctCountLabel.text = "答對 0 題"
        makeAQuestion()
        moveRock()
    }
    
}
