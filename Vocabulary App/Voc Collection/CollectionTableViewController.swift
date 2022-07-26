//
//  CollectionTableViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/29.
//

import UIKit
import AVFoundation

class CollectionTableViewController: UITableViewController {
    var collections: VocabularyList!
    let saver = Save()
    override func viewDidLoad() {
        super.viewDidLoad()
        collections.storeDetails(use: collections.collectedVocs)
    }
    
    
    @IBSegueAction func showCards(_ coder: NSCoder) -> CardCollectionViewCCollectionViewController? {
        let controller = CardCollectionViewCCollectionViewController(coder: coder)
        controller!.cards = collections
        controller?.isCollection = true
        return controller
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(collections.collectedVocs.count)
        return collections.collectedVocs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CollectionTableViewCell else { return CollectionTableViewCell() }
        cell.chLabel.text = collections.chinese[indexPath.row]
        cell.enLabel.text = collections.english[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let speaker = Speaker()
        speaker.pronounce(with: collections.english[indexPath.row], isEnglish: true)
        print(collections.english[indexPath.row])
        print("is speaking")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        collections?.collectedVocs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saver.save(vocs: collections.collectedVocs)
        tableView.reloadData()
    }

}
