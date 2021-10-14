//
//  Model.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 12.10.2021.
//

import Foundation
import Alamofire

class Character: RickMorty {
    var episodes: [String]
    
    override init?(_ data: NSDictionary) {
        guard let episodesArray = data["episode"] as? NSArray else {return nil}
        var array = [String]()
        for element in episodesArray {
            guard let final = element as? String else {return nil}
            array.append(final)
        }
        self.episodes = array
        
        super.init(data)
    }
    
    override init() {
        self.episodes = [""]
        super.init()
    }
}

func downloadCharacter (_ index: Int, completion: @escaping (Character) -> Void) {
    AF.request(generalUrl+"/\(index)").validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            guard let result = value as? NSDictionary,
                  let final = Character(result) else {return}
            completion(final)
        case .failure(let error):
            print(error)
        }
    }
}

func downloadEpisode (_ url: String, completion: @escaping (String) -> Void) {
    AF.request(url).validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            guard let dict = value as? NSDictionary,
                  let name = dict["name"] as? String,
                  let episode = dict["episode"] as? String else {return}
            completion("\(name): \(episode)")
        case .failure(let error):
            print(error)
        }
    }
}
