//
//  RecordSoundsViewController.swift
//  Le Pitch
//
//  Created by Paul Gaudin on 11/11/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio:RecordedAudio!
    

    @IBAction func recordAudio(sender: UIButton) {
        
        recordingLabel.text = "recording"
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
    
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        
//        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings : [:])
        
        audioRecorder.delegate = self
        
        audioRecorder.meteringEnabled = true
        
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
    
        if (flag){
        
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)

            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
        } else{
        
            print("error")
            
            recordButton.enabled = true
            stopButton.hidden = true
        
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
        
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            playSoundsVC.recievedAudio = data
        
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        recordingLabel.text = "Tap to record"

        recordButton.enabled = true
        
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setActive(false)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

