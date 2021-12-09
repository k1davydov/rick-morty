//
//  DetailModel.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 17.11.2021.
//

import Foundation
import UIKit
import Alamofire

struct DescriptionCharacter {
    let name: String
    let status: String
    let species: String
    let gender: String
    let location: String
    let episodes: [String]
    
    var image: UIImage
}

protocol DetailPresenterProtocol: UITableViewDataSource, UITableViewDelegate {
    init(tableView: UITableView, model: DescriptionCharacter, vc: UIViewController)
}



func downloadDescriptionCharacter(url: String, completion: @escaping (DescriptionCharacter) -> Void) {
    AF.request(url).validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            guard let data = descriptionCharacterParser(data: value) else {
                print("Error with parsed description charachter")
                return
            }
            downloadImage(data.5) { image in
                downloadEpisodes(data.6) { episodes in
                    let result = DescriptionCharacter(name: data.0, status: data.1, species: data.2, gender: data.3, location: data.4, episodes: episodes, image: image)
                    completion(result)
                }
            }
        case .failure(let error):
            print(error)
        }
    }
}

func descriptionCharacterParser(data: Any) -> (String, String, String, String, String, String, NSArray)? {
    guard let dict = data as? NSDictionary,
          let name = dict["name"] as? String,
          let status = dict["status"] as? String,
          let species = dict["species"] as? String,
          let gender = dict["gender"] as? String,
          let imageUrl = dict["image"] as? String,
          let location1 = dict["location"] as? NSDictionary, let location = location1["name"] as? String,
          let episodesArray = dict["episode"] as? NSArray else {
              print("Error when parsing the description charachter")
              return nil
          }
        return (name, status, species, gender, location, imageUrl, episodesArray)
}

func downloadEpisodes(_ urls: NSArray, completion: @escaping ([String]) -> Void) {
    var result = [String]()
    for element in urls {
        guard let url = element as? String else {return}
        downloadEpisode(url) { episode in
            result.append(episode)
            if result.count == urls.count {
                completion(result)
            }
        }
    }
}

func downloadEpisode(_ url: String, completion: @escaping (String) -> Void) {
    AF.request(url).validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            completion(episodeParser(value))
        case .failure(let error):
            print(error)
        }
    }
}

func episodeParser(_ data: Any) -> String {
    guard let dict = data as? NSDictionary,
          let name = dict["name"] as? String,
          let episode = dict["episode"] as? String else {
              print("Error when parsing episodes")
              return ""
          }
    return("\(name): \(episode)")
}

func heightForRow(_ index: IndexPath) -> CGFloat {
    if index.section == 0, index.row == 0 {
        return 350
    } else if index.section == 1 {
        return 40
    }
    return 60
}
