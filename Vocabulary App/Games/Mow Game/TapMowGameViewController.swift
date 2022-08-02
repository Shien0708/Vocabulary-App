//
//  TapMowGameViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/4.
//

import UIKit

class TapMowGameViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var wordCollectionView: UICollectionView!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var correctCountLabel: UILabel!
    
    var answerIndex = 0
    var time = 10
    var remainedSeconds = 0
    var vocs = VocabularyList()
    var isChineseQuestion = true
    var options = [(String, Int)]()
    var buttons = [UIButton]()
    var mowImageViews = [UIImageView]()
    var timer: Timer?
    var correctCounts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remainedSeconds = time
        timerLabel.text = "\(time)"
        makeQuestion()
    }
    
    
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.remainedSeconds -= 1
            self.timerLabel.text = "\(self.remainedSeconds)"
            if self.remainedSeconds == 0 {
                self.timer?.invalidate()
                self.againButton.isHidden = false
                self.buttons.map { button in
                    button.isEnabled = false
                    
                }
            }
        })
    }
    
    func makeQuestion() {
        options.removeAll()
        buttons.removeAll()
        mowImageViews.removeAll()
        setTimer()
        vocs.fetchAllVoc(with: vocs.letters[Int.random(in: 0...vocs.letters.count-2)])
        vocs.storeDetails(use: vocs.allVoc)
        for _ in 0...8 {
            var index = Int.random(in: 0...vocs.english.count-1)
            while options.contains(where: { word in
                word.1 == index
            }) {
                index = Int.random(in: 0...vocs.english.count-1)
            }
            if isChineseQuestion {
                options.append((vocs.english[index], index))
            } else {
                options.append((vocs.chinese[index], index))
            }
        }
        answerIndex = options[Int.random(in: 0...options.count-1)].1
        if isChineseQuestion {
            print(answerIndex)
            questionLabel.text = vocs.chinese[answerIndex]
        } else {
            questionLabel.text = vocs.english[answerIndex]
        }
        wordCollectionView.reloadData()
    }
    
    
    @IBAction func check(_ sender: UIButton) {
        timer?.invalidate()
        var touchedIndex = 0
        buttons.map { button in
            button.isEnabled = false
        }
        if Int((sender.titleLabel?.text)!)! == answerIndex {
            print("correct")
            while !buttons[touchedIndex].isTouchInside {
                touchedIndex += 1
            }
            sender.backgroundColor = .green
            correctCounts += 1
            correctCountLabel.text = "答對 \(correctCounts) 題"
            mowImageViews[touchedIndex].image = UIImage(named: "mow")
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                self.mowImageViews[touchedIndex].transform = CGAffineTransform.init(rotationAngle: CGFloat.pi*2)
            })
            UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
                self.mowImageViews[touchedIndex].transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
                }.startAnimation()
            
        } else {
            print("wrong")
            sender.backgroundColor = .red
            buttons.map { button in
                if answerIndex == Int((button.titleLabel?.text)!)! {
                    button.backgroundColor = .green
                }
            }
            while buttons[touchedIndex].backgroundColor != .green {
                touchedIndex += 1
            }
            mowImageViews[touchedIndex].image = UIImage(named: "mow")
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            self.makeQuestion()
        })
    }
    
    @IBAction func playAgain(_ sender: Any) {
        correctCounts = 0
        correctCountLabel.text = "答對 0 題"
        remainedSeconds = time
        makeQuestion()
        againButton.isHidden = true
    }
    
}


extension TapMowGameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TapMowGameCollectionViewCell else { return TapMowGameCollectionViewCell() }
        cell.wordView.layer.cornerRadius = cell.bounds.width/2
        cell.wordLabel.text = options[indexPath.item].0
        cell.wordButton.setTitle("\(options[indexPath.item].1)", for: .normal)
        cell.wordButton.isEnabled = true
        if cell.wordButton.backgroundColor != .clear {
            cell.wordButton.backgroundColor = .clear
        }
        buttons.append(cell.wordButton)
        cell.mowImageView.image = nil
        mowImageViews.append(cell.mowImageView)
        
        return cell
    }
}


extension TapMowGameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (wordCollectionView.bounds.width-30)/3, height: (wordCollectionView.bounds.width-30)/3)
    }
}
