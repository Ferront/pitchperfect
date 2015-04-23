//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Franck Ferront on 07/04/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import UIKit
import AVFoundation



class PlaySoundViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var rate: Float!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopAudio: UIButton!
    
    override func viewDidLoad() {
        
        var session=AVAudioSession.sharedInstance()
        let speaker=AVAudioSessionPortOverride.Speaker
        session.overrideOutputAudioPort(speaker, error: nil)
        
        super.viewDidLoad()
       
        audioEngine = AVAudioEngine()
        
        
        audioPlayer=AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
        audioPlayer.currentTime=0
        
        audioFile=AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initAll(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime=0
        stopAudio.enabled=true
    }
    
    func changePitch (myPitch:Float){
        initAll()
        audioPlayer.rate=myPitch
        audioPlayer.play()
    }
    
    @IBAction func playFast(sender: AnyObject) {
        changePitch(1.5)
    }
    
   @IBAction func playSlow(sender: AnyObject) {
        changePitch(0.5)
    }

    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playdarkvador(sender: UIButton) {
        playAudioWithVariablePitch(-900)
    }
    
    
    func playAudioWithVariablePitch(pitch:Float){
        initAll()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        stopAudio.enabled=false
    }
    
}
