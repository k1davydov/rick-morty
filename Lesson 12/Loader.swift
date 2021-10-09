//
//  Results.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 07.09.2021.
//

import Foundation
import Alamofire
import UIKit

struct Episodes {
    let name: String
    let episode: String
    
    init?(_ data: NSDictionary) {
        guard let name = data["name"] as? String,
              let episode = data["episode"] as? String
        else {
            return nil
        }
        self.name = name
        self.episode = episode
    }
}

struct RickMorty {
    let name: String
    let status: String
    let species: String
    let gender: String
    let imageURL: String
    let location: String
    let characterURL: String
    let episodes: NSArray
    
    init?(_ data: NSDictionary) {
        guard let name = data["name"] as? String,
              let status = data["status"] as? String,
              let species = data["species"] as? String,
              let gender = data["gender"] as? String,
              let imageURL = data["image"] as? String,
              let location1 = data["location"] as? NSDictionary, let location = location1["name"] as? String,
              let characterURL = data["url"] as? String,
              let episodes = data["episode"] as? NSArray
        else {
            return nil
        }
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.imageURL = imageURL
        self.location = location
        self.characterURL = characterURL
        self.episodes = episodes
    }
    
    init() {
        self.name = ""
        self.status = ""
        self.species = ""
        self.gender = ""
        self.imageURL = ""
        self.location = ""
        self.characterURL = ""
        self.episodes = NSArray()
    }
}

func downloadData(completion: @escaping ([RickMorty]) -> Void) {
    var rickMorty = [RickMorty]()
    AF.request("https://rickandmortyapi.com/api/character").validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            guard let jsonDict = value as? NSDictionary,
                  let jsonArray = jsonDict["results"] as? NSArray else {return}
            for element in jsonArray {
                guard let result = element as? NSDictionary,
                      let final = RickMorty(result) else {return}
                rickMorty.append(final)
                completion(rickMorty)
            }
        case .failure(let error):
            print(error)
        }
    }
}

func downloadImage(url: String, completion: @escaping (UIImage) -> Void) {
    AF.request(url).validate().responseData { responseData in
        switch responseData.result {
        case .success(let data):
            guard let image = UIImage(data: data) else {return}
            completion(image)
        case .failure(let error):
            print(error)
        }
    }
}
