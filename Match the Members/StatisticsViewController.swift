//
//  StatisticsViewController.swift
//  Match the Members
//
//  Created by Patrick Yin on 9/12/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    var longestStreak: Int!
    @IBOutlet weak var statisticsText: UILabel!
    
    var pastResults: [Result]!
    var order = ["Three rounds ago", "Two rounds ago", "Last round"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var text = "Big Bear says:\n\n\n\nYour longest streak is \(longestStreak!)!\n\n"
        
        for i in 0..<pastResults!.count {
            if pastResults.indices.contains(i) {
                if pastResults[i].correct == "correct" {
                    text += "\(order[i]), you were correct! You guessed \(pastResults[i].guess!). \n\n"
                } else {
                    text += "\(order[i]), you were incorrect! You guessed \(pastResults[i].guess!). The correct person was \(pastResults[i].answer!).\n\n"
                }
            }
        }
        print(text)
        statisticsText.text = text
    }
    
    @IBAction func gamePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
