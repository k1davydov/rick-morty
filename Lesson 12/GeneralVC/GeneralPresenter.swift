//
//  GeneralPresenter.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import Foundation
import UIKit

class GeneralPresenter: NSObject, GeneralPresenterProtocol {
    unowned let view: UITableView
    unowned let vc: UIViewController
    var model: [ListCharacter]
    let persistance = RealmPersistance.shared
    
    required init(view: UITableView, model: [ListCharacter], vc: UIViewController) {
        self.view = view
        self.model = model
        self.vc = vc
    }
    
    func showCharacters() {
        if Connectivity.isConnectedToInternet {
            checkActivityIndicator()
            print("Internet connection")
            alertOfLostConnectionisShowed = false
            downloadData(pageNumber: page) { characters in
                guard let model = parserCharacters(characters) else {
                    print("Error when parsing list character")
                    return
                }
                
                for i in 0..<model.count {
                    downloadImage(model[i].5) { image in
                        let result = ListCharacter(name: model[i].0, status: model[i].1, species: model[i].2, gender: model[i].3, image: image, location: model[i].6, characterUrl: model[i].7)
                        
                        if self.persistance.getListCharacters()!.count < 20 {
                            self.persistance.addListCharacter(result)
                        }
                        self.model.append(result)
                        self.view.reloadData()
                        self.downloadCashe(url: model[i].7)
                    }
                }
                page += 1
            }
        } else {
            print("Lost internet connection")
            if !alertOfLostConnectionisShowed {
                showAlert(vc: vc)
                alertOfLostConnectionisShowed = true
            }
            if let model = persistance.getListCharacters() {
                print("Have storage data")
                page = 2
                self.model = model
                view.reloadData()
            } else {
                print("Havn't storage data")
                let activityIndicator = UIActivityIndicatorView(frame: vc.view.frame)
                activityIndicator.startAnimating()
                vc.view.addSubview(activityIndicator)
                view.isHidden = true
                page = 1
            }
        }
    }
    
    func downloadCashe(url: String) {
        downloadDescriptionCharacter(url: url) { character in
            self.persistance.addDescriptionCharacter(character)
        }
    }
    
    func checkActivityIndicator() {
        if vc.view.subviews.last == UIActivityIndicatorView() {
            vc.view.subviews.last?.isHidden = true
            view.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == model.count-1, indexPath.row != 0 {
            if Connectivity.isConnectedToInternet {
                showCharacters()
            } else {
                if !alertOfLostConnectionisShowed {
                    showAlert(vc: vc)
                    alertOfLostConnectionisShowed = true
                }
                tableView.reloadData()
            }
        }
        
        let modelFinal = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralCell") as! GeneralTableViewCell
        cell.initGeneralCell(name: modelFinal.name, gender: modelFinal.gender, location: modelFinal.location, bigImage: modelFinal.image, status: modelFinal.status)
        return cell
    }
}
