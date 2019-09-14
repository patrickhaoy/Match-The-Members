//
//  MainViewController.swift
//  Match the Members
//
//  Created by Patrick Yin on 9/11/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // Start/Stop Game
    var gameRunning: Bool!
    var appRunning = false
    
    // User Interface
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var buttonList: [UIButton]!
    var selectedButton: UIButton?
    var correctButton: UIButton!
    
    @IBOutlet weak var timeLeftDisplay: UILabel!
    var timeLeft: Int!
    var timer = Timer()
    
    @IBOutlet weak var scoreDisplay: UILabel!
    var score: Int!
    
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // StatisticsViewController Data
    var longestStreak: Int!
    var streak: Int!
    var pastResults: [Result]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize default values
        buttonList = [button1, button2, button3, button4]
        streak = 0
        longestStreak = 0
        pastResults = [Result]()

        // Format button text
        for button in buttonList {
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
        }
        
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appRunning && gameRunning{
            for button in buttonList {
                button.isEnabled = true
            }
            countdown()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        appRunning = true
    }
    
    func startGame() {
        score = 0
        scoreDisplay.text = String(score)
        startNewRound()
    }
    
    func startNewRound() {
        selectedButton = nil
        timeLeft = 5
        timeLeftDisplay.text = String(timeLeft)
        countdown()
        
        // Populate image and buttons
        let correctMemberName = Constants.names.randomElement()
        memberImage.image = Constants.getImageFor(name: correctMemberName!)
        
        correctButton = buttonList.randomElement()
        correctButton.setTitle(correctMemberName!, for: .normal)
        
        var remainingMemberNames = Constants.names
        remainingMemberNames.removeAll { $0 == correctMemberName }
        for button in buttonList {
            if button != correctButton {
                let randomMemberName = remainingMemberNames.randomElement()
                button.setTitle(randomMemberName!, for: .normal)
                remainingMemberNames.removeAll { $0 == randomMemberName }
            }
        }
    }
    
    func countdown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timeLeft -= 1
        timeLeftDisplay.text = String(timeLeft)
        
        //Time running out equivalent to wrong answer
        if timeLeft == 0 {
            timer.invalidate()
            correctButton.backgroundColor = UIColor.green
            
            streak = 0
            resetButtons()
        }
    }
    
    func resetButtons() {
        updatePastResults()
        for button in buttonList {
            button.isEnabled = false
        }
        statisticsButton.isEnabled = false
        startButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let button = self.selectedButton {
                button.backgroundColor = UIColor.white
            }
            self.correctButton.backgroundColor = UIColor.white
            
            for button in self.buttonList {
                button.isEnabled = true
            }
            self.statisticsButton.isEnabled = true
            self.startButton.isEnabled = true
            self.startNewRound()
        }
    }
    
    @IBAction func startPressed(_ sender: Any) {
        gameRunning = !gameRunning
        if gameRunning {
            (sender as! UIButton).setTitle("Stop", for: [])
            for button in buttonList {
                button.isEnabled = true
            }
            startGame()
        } else {
            timer.invalidate()
            (sender as! UIButton).setTitle("Start", for: [])
            for button in buttonList {
                button.isEnabled = false
            }
        }
    }

    @IBAction func button1Pressed(_ sender: Any) {
        selectedButton = button1
        checkAccuracy()
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        selectedButton = button2
        checkAccuracy()
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        selectedButton = button3
        checkAccuracy()
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        selectedButton = button4
        checkAccuracy()
    }
    
    func checkAccuracy() {
        timer.invalidate()
        if correctButton == selectedButton {
            selectedButton!.backgroundColor = UIColor.green
            score += 1
            scoreDisplay.text = String(score)
            streak += 1
            longestStreak = max(streak, longestStreak)
        } else {
            selectedButton!.backgroundColor = UIColor.red
            correctButton.backgroundColor = UIColor.green
            streak = 0
        }
        resetButtons()
    }
    
    func updatePastResults() {
        if pastResults.count >= 3 {
            pastResults.removeFirst()
        }
        
        //print(selectedButton.currentTitle!)
        if let button = selectedButton {
            print("a")
            pastResults.append(Result(guess: button.currentTitle!, answer: correctButton.currentTitle!))
        } else {
            print("b")
            pastResults.append(Result(answer: correctButton.currentTitle!))
        }
    }
    
    @IBAction func statisticsPressed(_ sender: Any) {
        timer.invalidate()
        for button in buttonList {
            button.isEnabled = false
        }
        self.performSegue(withIdentifier: "toStatistics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StatisticsViewController
        destinationVC.longestStreak = longestStreak
        destinationVC.pastResults = pastResults
    }
}

struct Result {
    var guess: String!
    var answer: String!
    var correct: String!
    
    init(guess: String, answer: String) {
        self.guess = guess
        self.answer = answer
        
        if guess == answer {
            correct = "correct"
        } else {
            correct = "incorrect"
        }
    }
    
    init(answer: String) {
        self.guess = "nobody! Time ran out"
        self.answer = answer
        correct = "incorrect"
    }
}
