//
//  SpellingGameSettingViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/5.
//

import UIKit

class SpellingGameSettingViewController: UIViewController {
    @IBOutlet weak var speedButton: UIButton!
    
    @IBOutlet weak var torchImageView2: UIImageView!
    @IBOutlet weak var torchImageView1: UIImageView!
    var actions = [UIAction]()
    var second:Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSpeedButton()
        torchImageView1.image = UIImage.animatedImageNamed("torch-", duration: 1)
        torchImageView2.image = UIImage.animatedImageNamed("torch-", duration: 1)
        // Do any additional setup after loading the view.
    }
    
    func makeSpeedButton() {
        let speedNames = ["超快", "快", "中", "慢", "超慢"]
        let dropSpeed = [0.5 , 1, 3, 5, 8]
        speedButton.showsMenuAsPrimaryAction = true
        for (i,name)in speedNames.enumerated() {
            actions.append(UIAction(title: "\(name)", handler: {_ in
                self.second = dropSpeed[i]
            }))
        }
        speedButton.menu = UIMenu(children: actions)
    }
    
    
    @IBSegueAction func showSpellingGame(_ coder: NSCoder) -> SpellingGameViewController? {
        let controller = SpellingGameViewController(coder: coder)
        controller!.second = second
        return controller
    }
    
    @IBAction func backToSpellingSetting(_ segue: UIStoryboardSegue) {
    }
    
}
