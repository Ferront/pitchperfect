//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Franck Ferront on 07/04/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate
{

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mic: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var jeBosse: UIActivityIndicatorView!
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        stopButton.hidden=true
        jeBosse.hidden=true
    }
    
    @IBAction func RecordAudio(sender: UIButton) {
        // TODO show text
       
        recordingInProgress.text=nil
        stopButton.hidden=false
        mic.hidden=true   //I find more relevant to hide the button instead of mic.enable=true
        
        jeBosse.hidden=false
        jeBosse.startAnimating()
        
        // TODO record user voice
 
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()

        
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
      
        
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            
            // Task 1 initializer
            let recordedAudio=RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)

         
            //TODO send page
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("erreur recording")
            stopButton.hidden=true
            mic.hidden=false
        }
    }
    @IBAction func stopRecording(sender: UIButton) {

        recordingInProgress.text="Appuyer pour enregistrer"
        stopButton.hidden=true
        mic.hidden=false    //Show the microphone button again
        jeBosse.hidden=true
        jeBosse.stopAnimating()
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()

        audioSession.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundViewController=segue.destinationViewController as! PlaySoundViewController
            let data=sender as! RecordedAudio
            playSoundsVC.receivedAudio=data
        }
    }
    
    
}

