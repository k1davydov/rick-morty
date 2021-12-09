//
//  Persistance.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import Foundation
import RealmSwift
import UIKit

class RealmEpisode: Object {
    @objc dynamic var episode = ""
}

class RealmDescriptionCharacter: Object {
    @Persisted dynamic var name = ""
    @Persisted dynamic var status = ""
    @Persisted dynamic var species = ""
    @Persisted dynamic var gender = ""
    @Persisted dynamic var image: Data? = nil
    @Persisted dynamic var location = ""
    @Persisted var episodes: List<RealmEpisode>
}

class RealmListCharacter: Object {
    @objc dynamic var name = ""
    @objc dynamic var status = ""
    @objc dynamic var species = ""
    @objc dynamic var gender = ""
    @objc dynamic var image: Data? = nil
    @objc dynamic var location = ""
    @objc dynamic var characterUrl = ""
}

class RealmPersistance {
    static let shared = RealmPersistance()

    private let realm = try! Realm()
    
    func addListCharacter (_ character: ListCharacter) {
        let newCharacter = RealmListCharacter()
        newCharacter.name = character.name
        newCharacter.status = character.status
        newCharacter.species = character.species
        newCharacter.gender = character.gender
        newCharacter.image = character.image.jpegData(compressionQuality: 1)
        newCharacter.location = character.location
        try! realm.write({
            realm.add(newCharacter)
        })
    }

    func getListCharacters() -> [ListCharacter]? {
        let characters = realm.objects(RealmListCharacter.self)
        var result = [ListCharacter]()
        for character in characters {
            result.append(ListCharacter(name: character.name, status: character.status, species: character.species, gender: character.gender, image: UIImage(data: character.image!)!, location: character.location, characterUrl: character.characterUrl))
        }
        return result
    }
    
    func addDescriptionCharacter (_ character: DescriptionCharacter) {
        let newCharacter = RealmDescriptionCharacter()
        newCharacter.name = character.name
        newCharacter.status = character.status
        newCharacter.species = character.species
        newCharacter.gender = character.gender
        newCharacter.image = character.image.jpegData(compressionQuality: 1)
        newCharacter.location = character.location
        
        for episode in character.episodes {
            let newEpisode = RealmEpisode()
            newEpisode.episode = episode
            newCharacter.episodes.append(newEpisode)
        }
        try! realm.write({
            realm.add(newCharacter)
        })
    }
    
    func getDescriptonCharacter(name: String) -> DescriptionCharacter? {
        let characters = realm.objects(RealmDescriptionCharacter.self)
        let charactersWithName = characters.where {$0.name == name}
        guard let character = charactersWithName.first else {
            print("Don't have character with name: \(name)")
            return nil
        }
        var episodes = [String]()
        for episode in character.episodes {
            episodes.append(episode.episode)
        }
        guard let image = UIImage(data: character.image ?? Data(base64Encoded: "")!) else {
            print("Error when converting Image, when getting description character")
            return nil
        }
        let answer = DescriptionCharacter(name: character.name, status: character.status, species: character.species, gender: character.gender, location: character.location, episodes: episodes, image: image)
        return answer
    }
}
