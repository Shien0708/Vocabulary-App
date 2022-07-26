//
//  VocListTableViewController.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/28.
//

import UIKit
import AVFoundation

class VocListTableViewController: UITableViewController {
    var currentLetter = ""
    var list: VocabularyList?
    lazy var filteredVoc = list
    var stars = [UIButton]()
    var nums = [Int]()
    var touchedStarIndex = 0
    var touchedIndexes = [Int]()
    var isSearching = false
    let saver = Save()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
    }
    
    func setSearchBar() {
        let searchControl = UISearchController()
        searchControl.searchResultsUpdater = self
        navigationItem.searchController = searchControl
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @IBAction func collect(_ sender: UIButton) {
        touchedStarIndex = Int(sender.configuration!.title!)!
        if !isSearching {
            print("is not searching")
            if list?.collectedVocs.contains((list?.allVoc[touchedStarIndex])!) == false {
                list?.collectVoc(isCollected: true, voc: list!.allVoc[touchedStarIndex])
            } else {
                list?.collectVoc(isCollected: false, voc: (list?.allVoc[touchedStarIndex])!)
            }
        } else {
            print("is searching")
            if list?.collectedVocs.contains((filteredVoc?.allVoc[touchedStarIndex])!) == false {
                list?.collectVoc(isCollected: true, voc: (filteredVoc?.allVoc[touchedStarIndex])!)
            } else {
                list?.collectVoc(isCollected: false, voc: (filteredVoc?.allVoc[touchedStarIndex])!)
            }
        }
        saver.save(vocs: list!.collectedVocs)
        tableView.reloadData()
    }
    
    // cards practice
    
    @IBSegueAction func showCards(_ coder: NSCoder) -> CardCollectionViewCCollectionViewController? {
        let controller = CardCollectionViewCCollectionViewController(coder: coder)
        controller?.cards = list!
        controller!.isCollection = false
        return controller
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredVoc?.allVoc.count != 0 {
            return (filteredVoc?.allVoc.count)!
        }
        return list!.allVoc.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? VocListTableViewCell else { return VocListTableViewCell() }
        cell.numButton.setTitle("\(indexPath.row)", for: .normal)
       
        if !nums.contains(indexPath.row) {
            nums.append(indexPath.row)
            stars.append(cell.starButton)
        }
        
        if !isSearching {
            if list?.collectedVocs.contains((list?.allVoc[indexPath.row])!) == true {
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        } else if isSearching {
            if list?.collectedVocs.contains((filteredVoc?.allVoc[indexPath.row])!) == true {
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        
        if let filteredVoc = filteredVoc {
            cell.enLabel.text = filteredVoc.english[indexPath.row]
            cell.chLabel.text = filteredVoc.chinese[indexPath.row]
        } else {
            cell.enLabel.text = list!.english[indexPath.row]
            cell.chLabel.text = list!.chinese[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let speaker = Speaker()
        if isSearching {
            speaker.pronounce(with: filteredVoc!.english[indexPath.row], isEnglish: true)
        } else {
            speaker.pronounce(with: list!.english[indexPath.row], isEnglish: true)
        }
        print("is speaking")
    }
    
}

extension VocListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        isSearching = true
        if let list = list {
            if let searchText = searchController.searchBar.text?.lowercased(), searchText.isEmpty == false {
                var index = 0
                filteredVoc?.allVoc = list.allVoc.filter({ voc in
                   guard list.english[index].contains(searchText) else {
                       index += 1
                       return false
                    }
                    index += 1
                    return voc.localizedStandardContains(searchText.lowercased())
                })
            } else {
                list.fetchAllVoc(with: currentLetter)
                filteredVoc?.allVoc = list.allVoc
                isSearching = false
            }
            filteredVoc?.storeDetails(use: filteredVoc!.allVoc)
            stars.removeAll()
            tableView.reloadData()
        }
    }
    
}
