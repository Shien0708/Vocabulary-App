//
//  MemoryGameSettingViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/2.
//

import UIKit

class MemoryGameSettingViewController: UIViewController {
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var beachImageView: UIImageView!
    
    var level = 1
    var time = 0
    var actions = [UIAction]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimerButton()
        setLevelButton()
        // Do any additional setup after loading the view.
        beachImageView.image = UIImage.animatedImageNamed("beach-", duration: 5)
    }
    
    
    @IBSegueAction func showMemoryGame(_ coder: NSCoder) -> MemoryGameCollectionViewController? {
        let controller = MemoryGameCollectionViewController(coder: coder)
        controller?.currentLevel = level
        controller!.time = time
        return controller
    }
    func setTimerButton() {
        actions.removeAll()
        timerButton.showsMenuAsPrimaryAction = true
        let times = [0, 10, 30, 60, 90, 120]
        for time in times {
            actions.append(UIAction(title: "\(time) 秒", handler: { _ in
                self.time = time
            }))
        }
        timerButton.menu = UIMenu(children: actions)
    }

    
    func setLevelButton() {
        actions.removeAll()
        levelButton.showsMenuAsPrimaryAction = true
        let levels = [1, 2, 3, 4, 5]
        for level in levels {
            actions.append(UIAction(title: "關卡 \(level)", handler: { _ in
                self.level = level
            }))
        }
        levelButton.menu = UIMenu(children: actions)
    }
    
    
    @IBAction func backToMemorySetting(_ segue: UIStoryboardSegue) {
    }
    
}
