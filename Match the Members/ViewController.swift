//
//  ViewController.swift
//  Match the Members
//
//  Created by Patrick Yin on 9/11/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var matchTheMembers: UILabel!
    var gameRunning: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format "Match the Members" title
        matchTheMembers.numberOfLines = 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainViewController
        destinationVC.gameRunning = gameRunning
    }
    
    @IBAction func mainStartPressed(_ sender: Any) {
        gameRunning = true
        self.performSegue(withIdentifier: "startToMain", sender: self)
    }
}

