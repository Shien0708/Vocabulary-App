//
//  TapMowGameSettingViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/4.
//

import UIKit

class TapMowGameSettingViewController: UIViewController {
    var time = 10
    var actions = [UIAction]()
    
    @IBOutlet weak var timeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimerButton()
    }
    
    
    
    func setTimerButton() {
        actions.removeAll()
        timeButton.showsMenuAsPrimaryAction = true
        let times = [10, 20, 30, 40, 50, 60]
        for time in times {
            actions.append(UIAction(title: "\(time) 秒", handler: {_ in
                self.time = time
            }))
        }
        timeButton.menu = UIMenu(children: actions)
    }
    
    @IBSegueAction func showMowGame(_ coder: NSCoder) -> TapMowGameViewController? {
        let controller = TapMowGameViewController(coder: coder)
        controller?.time = time
        return controller
    }
    
    @IBAction func backToTapMowSetting(_ segue: UIStoryboardSegue) {
    }
    
}
