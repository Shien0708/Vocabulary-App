//
//  AlphabetsViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/28.
//

import UIKit
class AlphabetsViewController: UIViewController {
    var list: VocabularyList!
    var chosenLetter = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func press(_ sender: UIButton) {
        list.fetchAllVoc(with: (sender.configuration?.title)!)
        chosenLetter = (sender.configuration?.title)!
        list.storeDetails(use: list.allVoc)
        performSegue(withIdentifier: "showList", sender: nil)
    }
    
    
    @IBSegueAction func showList(_ coder: NSCoder) -> UITableViewController? {
        let controller = VocListTableViewController(coder: coder)
        controller?.currentLetter = chosenLetter
        controller?.list = list
        return controller
    }
    
    
}
