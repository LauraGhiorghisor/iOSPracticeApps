//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // Programme specific
    var timer: Timer?
    var runCount: Int = 0
    var selectedSeconds: Double = 60
    let times: [String: Double] = ["Soft": 5, "Medium": 8, "Hard": 12*60]
    
    // Audio
    var player: AVAudioPlayer!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        let hardness = sender.currentTitle!

        initalize()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + times[hardness]!*60) {
//                        self.doneLabel.alpha = 1
//                    }
        //NOTE
        //Must unwrap twice because of: 1. the tittle of the button and then 2. the dictionary key itself.
        
        selectedSeconds = times[hardness]!
        timer?.invalidate()
        runCount = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
       initalize()
    }
    
    func initalize(){
         doneLabel.alpha = 0
    }
    
    @objc func fireTimer() {
           print("\(runCount)")
           runCount += 1

        if runCount%60 < 10 {
            secondLabel.text = "0\(runCount%60)"
        } else {
             secondLabel.text = "\(runCount%60)"
        }
         if runCount/60 < 10 {
        minuteLabel.text = "0\(runCount/60)"
         } else {
            minuteLabel.text = "\(runCount/60)"
        }
        progressBar.progress = Float(runCount)/Float(selectedSeconds)
           if runCount == Int(selectedSeconds) {
               timer?.invalidate()
            runCount = 0
            doneLabel.alpha = 1
            playSound(s: "alarm_sound")
           }
       }
    
    func playSound(s: String) {
          let url = Bundle.main.url(forResource: s, withExtension: "mp3")
          player = try! AVAudioPlayer(contentsOf: url!)
          player.play()

      }
}
