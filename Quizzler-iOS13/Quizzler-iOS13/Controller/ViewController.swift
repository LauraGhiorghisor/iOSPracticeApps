//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!

    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var timer: Timer!
    // whyyyyyyyyyy
    
   
    var quizBrain = QuizBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

       updateUI()
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        let answer = sender.currentTitle
//        let actualAnswer = quiz[questionNumber].answer
            let userGotIt = quizBrain.checkAnswer(answer!)
        
         sender.layer.cornerRadius = 20
        
        if userGotIt {
           
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            
        } else {
            
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
        
        
        quizBrain.nextQuestion()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
    }

   @objc func updateUI(){
        questionLabel.text = quizBrain.getQuestionText()
        progressbar.progress = quizBrain.getProgress()
    
        answer1Button.backgroundColor = UIColor.clear
        answer2Button.backgroundColor = UIColor.clear
        answer3Button.backgroundColor = UIColor.clear

        answer1Button.setTitle( quizBrain.getAnswers()[0], for: .normal)
        answer2Button.setTitle( quizBrain.getAnswers()[1], for: .normal)
        answer3Button.setTitle( quizBrain.getAnswers()[2], for: .normal)
    
        scoreLabel.text = "Score: \(quizBrain.getScore())"
    }
}

