//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by Ting Chun Chou on 1/26/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //進入畫面之後只有錄音鈕可以按 所以 stopRecoringButton.isEnable = false <＝不能按
        //就等於下面那個停止紐不能按
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }

    //Fix Requirement
    func configureRecrodingButtons(isRecording: Bool){
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        if isRecording {
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            
        }else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }



    @IBAction func recordAudio(_ sender: Any) {
        //recordingLabel.text = "...in Progress"
        //開始錄音的鈕按下去 開始錄音的鈕就不能再按第二次 所以recordButton.isEnable = false <=不能按
        //但是停止錄音的紐可以按
        //stopRecordingButton.isEnabled = true
        //recordButton.isEnabled = false
        //code below is to tell recordAudio to start recording audio
        
        
        //call the function to check if its recording or not
        configureRecrodingButtons(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        //recordButton.isEnabled = true
        //stopRecordingButton.isEnabled = false
        //recordingLabel.text = "Tap to Record"
        //below is to tell stopRecording to stopRecording
        
        //call the function to check if its not recording
        configureRecrodingButtons(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)}
        else{
            print("recording was not successful")
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
   
}

//Adding Delegation To RecordSoundsVC
//Remember that protocols act as a kind of contract. AVAudioRecorder does not know what classes you have in your app. However, if you say that your class conforms to the AVAudioRecorderDelegate protocol, then it knows it can call a specific function in your class.

//The specific function has been defined in the protocol (in this case, the AVAudioRecorderDelegate protocol). This way your class and the AVAudioRecorder are loosely coupled, and they can work together without having to know much about each other.

//Loose coupling of classes is really useful in building interchangeable pieces of code, and used quite a lot in iOS.
