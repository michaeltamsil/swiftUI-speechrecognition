//
//  SpeechRec.swift
//  speech01
//
//  Created by michael tamsil on 30/09/20.
//

import Foundation
import Speech
import SwiftUI

public class SpeechRec: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id-ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @Published var hasil: String?
    
    // MARK: View Controller Lifecycle
    
    public override init() {
        super.init()
        reqSpeechAuthorization()
    }
    
    func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Undable to create a SFSpeechAudioBufferRecognitionRequest object")}
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                //Update the text view with the results.
                print(result.bestTranscription.formattedString)
                isFinal = result.isFinal
                print(result.transcriptions.last?.formattedString)
                
                self.hasil = result.bestTranscription.formattedString
                if result.isFinal {
                    print("final")
                }else {
                    print("bukan final")
                }
                
                
                print(self.hasil ?? "")
                
            }
            
            
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
            
            
        }
        
        //configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    
    
    private func reqMicrophoneAuthorization(){
        
    }
    
    private func reqSpeechAuthorization() {
        print("masuk")
        SFSpeechRecognizer.requestAuthorization{ authStatus in
            
            // diver tto the app's main thread so that the UI
            // can be updated
            OperationQueue.main.addOperation {
                switch authStatus {
                case.authorized:
                    break
                case .denied:
                    print("user denied access to speech recognition")
                    break
                case .restricted:
                    print("Speech recognition restricted on this device")
                    break
                case .notDetermined:
                    print("Speech recognition not yet authorized")
                    break
                default:
                    print("speech approved")
                }
            }
        }
    }
    
    
}
