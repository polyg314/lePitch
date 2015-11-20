//
//  PlaySoundsViewController.swift
//  Le Pitch
//
//  Created by Paul Gaudin on 11/11/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    var movieSound:NSURL = NSURL()
    
    var recievedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    
    var audioFile:AVAudioFile!
    
    @IBAction func playSlowedDown(sender: AnyObject) {
        playerPlay(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playerPlay(2.0)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playWithPitch(1000)
    }
    
    @IBAction func playDarth(sender: UIButton) {
        playWithPitch(-1000)
    }
    
    func stopAudios(){
        player.stop()
        if audioEngine.running{
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    func playWithPitch(pitch:Float){
        
        playingStopButton.hidden = false
        
        stopAudios()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: soundEnded)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func soundEnded(){
    
        playingStopButton.hidden = true
     
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        playingStopButton.hidden = true
    }
    
    @IBOutlet weak var playingStopButton: UIButton!
    
    @IBAction func stopSound(sender: AnyObject) {
            stopAudios()
            playingStopButton.hidden = true
            player.currentTime = 0.0
    }
    
    func playerPlay(rate:Float){
        stopAudios()
        player.delegate = self
        player.currentTime = 0.0
        player.rate = rate
        player.prepareToPlay()
        player.play()
        playingStopButton.hidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recievedAudio.filePathUrl)

        do{
            player = try AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
            player.enableRate = true
            
        }catch{
            print("error with the sound")
        }

    }

}
