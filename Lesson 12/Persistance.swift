//
//  Persistance.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import Foundation


class Persistance {
    static let shared = Persistance()
    
    private let generalUrlKey = "Persistance.generalUrlKey"
    
    var generalUrl: String? {
        set {UserDefaults.standard.set(newValue, forKey: generalUrlKey)}
        get {return UserDefaults.standard.string(forKey: generalUrlKey)}
    }
}
