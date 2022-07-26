//
//  Vocabularies.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/28.
//

import Foundation

class VocabularyList {
    var allVoc = [String]()
    var vocDetails = [String]()
    var english = [String]()
    var chinese = [String]()
    var enSentences = [String]()
    var chSenteces = [String]()
    var collectedVocs = [String]()
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Y", "Z"]
    
    func fetchAllVoc(with letter: String) {
        let path = Bundle.main.url(forResource: letter, withExtension: "txt")
    
        let content = try? String(data: Data(contentsOf: path!), encoding: .utf16)
        if let content = content {
            allVoc = content.components(separatedBy: "\n")
        } else {
            print("no voc content")
        }
    }
    
    func storeDetails(use allVocs: [String]) {
        english.removeAll()
        chinese.removeAll()
        enSentences.removeAll()
        chSenteces.removeAll()
        vocDetails.removeAll()
        
        if !allVocs.isEmpty {
            for voc in allVocs {
                vocDetails += voc.components(separatedBy: "\t")
            }
            var num = 0
            for (i,string) in vocDetails.enumerated() {
                num = (i+1)%4
                switch num {
                case 1:
                    english.append(string)
                case 2:
                    chinese.append(string)
                case 3:
                    enSentences.append(string)
                case 0:
                    chSenteces.append(string)
                default:
                    print("something wrong with details")
                }
            }
        }
    }
    
    func collectVoc(isCollected: Bool, voc: String) {
        var index = 0
        if isCollected {
            collectedVocs.append(voc)
        } else {
            if collectedVocs.contains(voc) {
                while collectedVocs[index] != voc {
                    index += 1
                }
                collectedVocs.remove(at: index)
            }
        }
    }
    
}
