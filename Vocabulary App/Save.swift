//
//  Save.swift
//  Vocabulary App
//
//  Created by Shien on 2022/7/4.
//

import Foundation

class Save {
    
    func load()->[String]? {
        UserDefaults.standard.object(forKey: "collections") as? [String]
    }
    
    func save(vocs: [String]) {
        UserDefaults.standard.set(vocs, forKey: "collections")
    }
}
