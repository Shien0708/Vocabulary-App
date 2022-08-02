//
//  MemoryGameCollectionViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/2.
//

import UIKit

class MemoryGameCollectionViewController: UICollectionViewController {
    var vocs = VocabularyList()
    var currentQuestions = [(String, Int)]()
    var currentLevel = 6
    
    var isFirstTouch = true
    var openedItemIndexes = [Int]()
    var touchedItemIndexes = [Int]()
    var preOpenIndex = 0
    var currentQuestionCounts: Int {
        currentLevel * 4
    }
    var matchCounts = 0
    
    var allViews = [UIView]()
    var allWords = [UILabel]()
    var allButtons = [UIButton]()
    var allImageViews = [UIImageView]()
    
    var time = 0
    var timer: Timer?
    var timerLabel = UILabel()
    var againButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestions()
        setTimer()
    }

    func setTimer() {
        if time != 0 {
            var seconds = time
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                seconds -= 1
                self.timerLabel.text = "\(seconds)"
                if seconds == 0 {
                    self.timer?.invalidate()
                    self.againButton.isHidden = false
                    for button in self.allButtons {
                        button.isEnabled = false
                    }
                }
            })
        }
    }

    func showQuestions() {
        currentQuestions.removeAll()
        matchCounts = 0
        isFirstTouch = true
        againButton.isHidden = true
        for button in self.allButtons {
            button.isEnabled = true
        }
        
        for i in 0...(currentQuestionCounts/2)-1 {
            vocs.fetchAllVoc(with: vocs.letters[Int.random(in: 0...vocs.letters.count-1)])
            vocs.storeDetails(use: vocs.allVoc)
            let index = Int.random(in: 0...vocs.english.count-1)
            currentQuestions.append((vocs.english[index], i))
            currentQuestions.append((vocs.chinese[index], i))
        }
        currentQuestions.shuffle()
        
        for button in self.allButtons {
            button.isEnabled = true
        }
        for word in allWords {
            word.isHidden = true
        }
    }
    
    @IBAction func check(_ sender: UIButton) {
        let index = Int((sender.titleLabel?.text)!)!
        var i = 0
        
        while !allButtons[i].isTouchInside {
            i += 1
        }
        
        if touchedItemIndexes.count == 2 {
            touchedItemIndexes.removeAll()
        }
        
        touchedItemIndexes.append(i)
        
        for i in touchedItemIndexes {
            allButtons[i].isEnabled = false
        }
        
        let animation = Animation()
        animation.startRotate(with: allViews[i])
        allImageViews[i].image = UIImage(named: "shellBack")
        allWords[i].isHidden = false
        
        //點擊第二個貝殼
        if !isFirstTouch {
            isFirstTouch = true
            //答錯
            if index != preOpenIndex {
                for button in allButtons {
                    button.isEnabled = false
                }
                _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                    for i in self.touchedItemIndexes {
                        self.allWords[i].isHidden = true
                        self.allImageViews[i].image = UIImage(named: "shell")
                    }
                    for (i,button) in self.allButtons.enumerated() {
                        if self.openedItemIndexes.contains(i) {
                            continue
                        } else {
                            button.isEnabled = true
                        }
                    }
                })
                
            } else { //答對
                for i in touchedItemIndexes {
                    openedItemIndexes.append(i)
                    allButtons[i].isEnabled = false
                    matchCounts += 1
                }
                if matchCounts == allButtons.count {
                    timer?.invalidate()
                    
                    againButton.isHidden = false
                }
                
            }
        } else {
            allButtons[touchedItemIndexes.last!].isEnabled = false
            isFirstTouch = false
            preOpenIndex = index
        }
        print(touchedItemIndexes)
        print(openedItemIndexes)
    }
    
    
    @IBAction func playAgain(_ sender: Any) {
        openedItemIndexes.removeAll()
        touchedItemIndexes.removeAll()
        showQuestions()
        setTimer()
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return currentQuestionCounts
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MemoryGameCollectionViewCell else { return MemoryGameCollectionViewCell() }
        
        cell.wordLabel.text = currentQuestions[indexPath.item].0
        cell.wordButton.setTitle("\(currentQuestions[indexPath.item].1)", for: .normal)
        cell.shellImageView.image = UIImage(named: "shell")
        if allButtons.count != currentQuestionCounts {
            allWords.append(cell.wordLabel)
            allViews.append(cell.wordView)
            allButtons.append(cell.wordButton)
            allImageViews.append(cell.shellImageView)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
}

extension MemoryGameCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if currentLevel > 1 {
            return CGSize(width: (view.bounds.width-10)/4, height: (view.bounds.width-10)/4)
        } else {
            return CGSize(width: (view.bounds.width-20)/2, height: (view.bounds.width-20)/2)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! MemoryGameCollectionReusableView
        timerLabel = view.timerLabel
        againButton = view.againButton
        view.timerLabel.text = "\(time)"
        
        return view
    }
}
