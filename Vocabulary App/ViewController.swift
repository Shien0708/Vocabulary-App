//
//  ViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/28.
//

import UIKit

class ViewController: UIViewController {
    var vocs = VocabularyList()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        let loader = Save()
        vocs.collectedVocs = loader.load() ?? []
        // Do any additional setup after loading the view.
    }
   
    
    @IBSegueAction func showList(_ coder: NSCoder) -> AlphabetsViewController? {
        let controller = AlphabetsViewController(coder: coder)
        controller?.list = vocs
        return controller
    }
    
    @IBSegueAction func showCollections(_ coder: NSCoder) -> CollectionTableViewController? {
        let controller = CollectionTableViewController(coder: coder)
        controller?.collections = vocs
        return controller
    }
}

