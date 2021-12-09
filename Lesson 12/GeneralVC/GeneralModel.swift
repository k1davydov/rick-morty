//
//  GeneralModel.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import Foundation
import UIKit
import Alamofire

struct ListCharacter {
    let name: String
    let status: String
    let species: String
    let gender: String
    var image: UIImage
    let location: String
    let characterUrl: String
}

protocol GeneralPresenterProtocol: UITableViewDataSource {
    init(view: UITableView, model: [ListCharacter], vc: UIViewController)
}

func showAlert(vc: UIViewController) {
    let alert = UIAlertController(title: "Lost internet connection", message: "Try to connect", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    vc.present(alert, animated: true, completion: nil)
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

func downloadData(pageNumber: Int, completion: @escaping (Any) -> Void) {
    let params = ["page":pageNumber]
    AF.request(generalUrl+"/character", parameters: params).validate().responseJSON { responseJSON in
        switch responseJSON.result {
        case .success(let value):
            completion(value)
        case .failure(let error):
            print(error)
        }
    }
}

func parserCharacters(_ data: Any) -> [(String, String, String, String, UIImage, String, String, String)]? {
    guard let dictionary = data as? NSDictionary,
          let array = dictionary["results"] as? NSArray else {return nil}
    var result = [(String, String, String, String, UIImage, String, String, String)]()
    for element in array {
        guard let character = parserListCharacter(element) else {
            print("Ошибка при парсинге: \(element)")
            return nil
        }
        result.append(character)
    }
    return result
}

func parserListCharacter(_ data: Any) -> (String, String, String, String, UIImage, String, String, String)? {
    guard let dict = data as? NSDictionary,
          let name = dict["name"] as? String,
          let status = dict["status"] as? String,
          let species = dict["species"] as? String,
          let gender = dict["gender"] as? String,
          let imageUrl = dict["image"] as? String,
          let location1 = dict["location"] as? NSDictionary, let location = location1["name"] as? String,
          let characterUrl = dict["url"] as? String else {
              print("Error when parsing the list character")
              return nil
          }
    return (name, status, species, gender, UIImage(systemName: "person")!, imageUrl, location, characterUrl)
}

func chooseColor(status: String) -> UIColor {
    switch status {
    case "Alive":
        return .systemGreen
    case "Dead":
        return .systemRed
    default:
        return .systemOrange
    }
}
