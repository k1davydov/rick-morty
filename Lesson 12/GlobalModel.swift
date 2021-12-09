//
//  Constants.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 08.12.2021.
//

import Foundation
import Alamofire

let generalUrl = "https://rickandmortyapi.com/api"
var page = 1
var alertOfLostConnectionisShowed = false

class Connectivity {
    static var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
