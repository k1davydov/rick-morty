//
//  Results.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 07.09.2021.
//

import Foundation
import Alamofire
import UIKit

public var generalUrl = "https://rickandmortyapi.com/api/character"

class myData {
    var nextPage: String
    
    var characters: [RickMorty]
    
    init?(_ data: NSDictionary) {
        guard let result = data["info"] as? NSDictionary,
              let final = result["next"] as? String
        else {
            return nil
        }
        
        guard let result = data["results"] as? NSArray
        else {
            return nil
        }
        var characters = [RickMorty]()
        for element in result {
            guard let data = element as? NSDictionary,
                  let character = RickMorty(data)
            else {return nil}
            characters.append(character)
        }
        
        self.characters = characters
        self.nextPage = final
    }
    
    init() {
        self.nextPage = ""
        self.characters = [RickMorty()]
    }
}

class RickMorty {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let imageURL: String
    let location: String
    let characterURL: String
    
    init?(_ data: NSDictionary) {
        guard let id = data["id"] as? Int,
              let name = data["name"] as? String,
              let status = data["status"] as? String,
              let species = data["species"] as? String,
              let gender = data["gender"] as? String,
              let imageURL = data["image"] as? String,
              let location1 = data["location"] as? NSDictionary, let location = location1["name"] as? String,
              let characterURL = data["url"] as? String else {return nil}
        
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.imageURL = imageURL
        self.location = location
        self.characterURL = characterURL
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.status = ""
        self.species = ""
        self.gender = ""
        self.imageURL = ""
        self.location = ""
        self.characterURL = ""
    }
}

func downloadCharacters(_ url: String, completion: @escaping (myData) -> Void) {
    
    AF.request(url).validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            guard let jsonDict = value as? NSDictionary,
                  let result = myData(jsonDict) else {return}
            completion(result)
        case .failure(let error):
            print(error)
        }
    }
}

func downloadImage(_ index: Int, completion: @escaping (UIImage) -> Void) {
    AF.request(generalUrl+"/avatar/\(index).jpeg").validate().responseData { responseData in
        switch responseData.result {
        case .success(let data):
            guard let image = UIImage(data: data) else {return}
            completion(image)
        case .failure(let error):
            print(error)
        }
    }
}
