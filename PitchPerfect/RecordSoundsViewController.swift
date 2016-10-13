//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jena Grafton on 3/8/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("view will appear called")
        stopRecordingButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("record button pressed")
        changeButtons(buttonText: "Recording in progress", hidden: false, enabled: false)
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording pressed")
        changeButtons(buttonText: "Tap Mic to Record", hidden: true, enabled: true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            //Save the recorded audio
            recordedAudio = recorder.url as NSURL!
            
            //Move to the next scene aka perform segue
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            print("Recording not successfull")
            changeButtons(hidden: true, enabled: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            print("Recorded Audio URL: \(recordedAudioURL)")
            playSoundsVC.recordedAudioURL  = recordedAudioURL
        }
    }
    
    func changeButtons(buttonText: String? = nil, hidden: Bool, enabled: Bool) {
        if let buttonText = buttonText {
            recordingLabel.text = buttonText
        }
        
        if hidden == true {
            stopRecordingButton.isHidden = hidden
        } else if hidden == false {
            stopRecordingButton.isHidden = hidden
        }
        
        if enabled == true {
            recordButton.isEnabled = enabled
        } else if enabled == false {
                recordButton.isEnabled = enabled
        }
    }
    
    
}

