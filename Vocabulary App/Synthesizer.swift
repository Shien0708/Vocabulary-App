//
//  Synthesizer.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/30.
//

import Foundation
import AVFoundation


class Speaker {
    var synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    func pronounce(with string: String, isEnglish: Bool) {
        utterance = AVSpeechUtterance(string: string)
        if isEnglish {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        }
        synthesizer.speak(utterance)
    }
}
