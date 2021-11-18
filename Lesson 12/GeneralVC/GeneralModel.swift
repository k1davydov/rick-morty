//
//  GeneralModel.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import Foundation
import UIKit
import Alamofire

var generalUrl = "https://rickandmortyapi.com/api/character"
var generalNextPage: String?
var alertOfConnectionShowed = false

struct RickMorty {
    let name: String
    let status: (String, UIColor)
    let species: String
    let gender: String
    
    var image: UIImage
    
    let episodeUrl: NSArray
    let imageUrl: String
    let locationUrl: String
    let characterUrl: String
}

class Connectivity {
    static var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

protocol GeneralPresenterProtocol: UITableViewDataSource {
    init(view: UITableView, model: [RickMorty])
}

func checkInternetConnection(_ vc: UIViewController) {
    guard !Connectivity.isConnectedToInternet else {
        alertOfConnectionShowed = false
        return
    }
    
    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
        if Connectivity.isConnectedToInternet {
            timer.invalidate()
        }
        print("Check Internet connection")
    }
    guard !alertOfConnectionShowed else {return}
    let alert = UIAlertController(title: "Lost internet connection", message: "Try to connect", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    vc.present(alert, animated: true, completion: nil)
    alertOfConnectionShowed = true
}

func downloadImage(_ url: String, completion: @escaping (UIImage) -> Void) {
    AF.request(url).validate().responseData { responseData in
        switch responseData.result {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                print("Ошибка при загрузке изображения")
                return}
            completion(image)
        case .failure(let error):
            print("Ошибка при загрузке изображения по адресу: \(url) - \(error)")
        }
    }
}

func downloadData(_ url: String, completion: @escaping (Any) -> Void) {
    AF.request(url).validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            completion(value)
        case .failure(let error):
            print(error)
        }
    }
}

func parserCharacters(_ data: Any) -> [RickMorty] {
    guard let dictionary = data as? NSDictionary,
          let info = dictionary["info"] as? NSDictionary, let nextPage = info["next"] as? String?,
          let array = dictionary["results"] as? NSArray else {return [RickMorty]()}
    generalNextPage = nextPage
    var rickMortys = [RickMorty]()
    for element in array {
        guard let rickMorty = parserOneCharacter(element) else {return [RickMorty]()}
        rickMortys.append(rickMorty)
    }
    return rickMortys
}

func parserOneCharacter(_ data: Any) -> RickMorty? {
    guard let dict = data as? NSDictionary,
          let name = dict["name"] as? String,
          let status = dict["status"] as? String,
          let species = dict["species"] as? String,
          let gender = dict["gender"] as? String,
          let imageUrl = dict["image"] as? String,
          let location = dict["location"] as? NSDictionary, let locationUrl = location["name"] as? String,
          let characterUrl = dict["url"] as? String,
          let episode = dict["episode"] as? NSArray else {
              print("Ошибка при парсинге данных персонажа")
              return nil
          }
    var statusFinal: (String, UIColor) = ("Unknown", .systemOrange)
    switch status {
    case "Alive":
        statusFinal = ("Alive", .systemGreen)
    case "Dead":
        statusFinal = ("Dead", .systemRed)
    default:
        statusFinal = ("Unknown", .systemOrange)
    }
    let rickMorty = RickMorty(name: name, status: statusFinal, species: species, gender: gender, image: UIImage(systemName: "person")!, episodeUrl: episode, imageUrl: imageUrl, locationUrl: locationUrl, characterUrl: characterUrl)
    return rickMorty
}
