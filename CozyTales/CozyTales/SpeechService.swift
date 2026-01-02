//
//  SpeechService.swift
//  CozyTales
//
//  Created by Hye Ri Kim on 1/1/26.
//

import AVFoundation
internal import Combine

@MainActor
final class SpeechService: NSObject, ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String) {
        stop()
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 필요하면 ko-KR로 변경
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.2
        utterance.postUtteranceDelay = 0.2
        
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechService: AVSpeechSynthesizerDelegate {}
