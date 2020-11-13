//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
//
//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController {
//
//    var player: AVAudioPlayer?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//
//    @IBAction func keyPressed(_ sender: UIButton) {
//
//        playSound()
//    }
//
//
//   func playSound() {
//        guard let url = Bundle.main.url(forResource: "C", withExtension: "waw") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let player = player else {return}
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//}
import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer!
//    var x: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func keyPressed(_ sender: UIButton) {
        playSound(s: sender.titleLabel!.text!)
        sender.alpha = 0.5
        let seconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            sender.alpha = 1
              
        }
  
        
        print(sender.titleLabel!.text!)
        //or print(sender.currentTitle)
        
        
    }

    func playSound(s: String) {
        let url = Bundle.main.url(forResource: s, withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()

    }
}

