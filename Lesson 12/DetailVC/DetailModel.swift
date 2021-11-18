//
//  DetailModel.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 17.11.2021.
//

import Foundation
import UIKit
import Alamofire

protocol DetailPresenterProtocol: UITableViewDataSource, UITableViewDelegate {
    init(tableView: UITableView, model: RickMorty)
}

func downloadEpisodes(_ urls: NSArray, completion: @escaping (String) -> Void) {
    for element in urls {
        guard let url = element as? String else {return}
        downloadEpisode(url) { episode in
            completion(episode)
        }
    }
}

func heightForRow(_ index: IndexPath) -> CGFloat {
    if index.section == 0, index.row == 0 {
        return 350
    } else if index.section == 1 {
        return 40
    }
    return 60
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
              print("Ошибка при парсинге эпизодов")
              return ""
          }
    return("\(name): \(episode)")
}
