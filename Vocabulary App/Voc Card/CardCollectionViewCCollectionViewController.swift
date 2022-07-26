//
//  CardCollectionViewCCollectionViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/30.
//

import UIKit

class CardCollectionViewCCollectionViewController: UICollectionViewController {
    var cards: VocabularyList!
    var currentCardIndex = 0
    
    var cardViews = [UIView]()
    var wordLabels = [UILabel]()
    var sentenceLabels = [UILabel]()
    var buttonNums = [Int]()
    
    var isCollection = false
    var isEnglish = [Bool]()
    
    let speaker = Speaker()
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCollection {
            isEnglish = [Bool](repeating: true, count: cards.collectedVocs.count)
            cards.storeDetails(use: cards.collectedVocs)
        } else {
            isEnglish = [Bool](repeating: true, count: cards.allVoc.count)
            cards.storeDetails(use: cards.allVoc)
        }
      
    }
    
    @IBAction func flip(_ sender: UIButton) {
        let index = Int((sender.titleLabel?.text)!)!
        let animation = Animation()
        animation.startRotate(with: cardViews[index])
        if isEnglish[index] == true {
            isEnglish[index] = false
            wordLabels[index].text = cards.chinese[index]
            sentenceLabels[index].text = cards.chSenteces[index]
        } else {
            isEnglish[index] = true
            wordLabels[index].text = cards.english[index]
            sentenceLabels[index].text = cards.enSentences[index]
        }
        
    }
    
    @IBAction func pronounce(_ sender: Any) {
        if isEnglish[currentCardIndex] {
            speaker.pronounce(with: cards.english[currentCardIndex], isEnglish: true)
        } else {
            speaker.pronounce(with: cards.chinese[currentCardIndex], isEnglish: false)
        }
    }
    
    
    @IBAction func saySentence(_ sender: Any) {
        
        if isEnglish[currentCardIndex] == true {
            speaker.pronounce(with: cards.enSentences[currentCardIndex],isEnglish: true)
        } else {
            speaker.pronounce(with: cards.chSenteces[currentCardIndex], isEnglish: false)
        }
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if !isCollection {
            return cards.allVoc.count
        } else {
            return cards.collectedVocs.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectionViewCell else { return CardCollectionViewCell() }
        
        if isEnglish[indexPath.item] == true {
            cell.wordLabel.text = cards.english[indexPath.item]
            cell.sentenceLabel.text = cards.enSentences[indexPath.item]
        } else {
            cell.wordLabel.text = cards.chinese[indexPath.item]
            cell.sentenceLabel.text = cards.chSenteces[indexPath.item]
        }
        cell.flipButton.setTitle("\(indexPath.item)", for: .normal)
        if !buttonNums.contains(indexPath.item) {
            buttonNums.append(indexPath.item)
            wordLabels.append(cell.wordLabel)
            sentenceLabels.append(cell.sentenceLabel)
            cardViews.append(cell.cardView)
        }
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   
}

extension CardCollectionViewCCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width, height: view.bounds.height-50)
    }
    
}

extension CardCollectionViewCCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentCardIndex = Int(scrollView.contentOffset.x/view.bounds.width)
    }
}
