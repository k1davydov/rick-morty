//
//  DetailPresenter.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 17.11.2021.
//

import Foundation
import UIKit

class DetailPresenter: NSObject, DetailPresenterProtocol {
    unowned let tableView: UITableView
    let vc: UIViewController
    private var model: DescriptionCharacter
    private var persistance = RealmPersistance.shared
    
    required init(tableView: UITableView, model: DescriptionCharacter, vc: UIViewController) {
        self.tableView = tableView
        self.model = model
        self.vc = vc
    }
    
    func showCharacter(url: String, name: String) {
        if Connectivity.isConnectedToInternet {
            downloadDescriptionCharacter(url: url) { character in
                self.model = character
                self.tableView.reloadData()
                self.vc.navigationItem.title = character.name
            }
        } else {
            print("Lost internet connection")
            if !alertOfLostConnectionisShowed {
                showAlert(vc: vc)
                alertOfLostConnectionisShowed = true
            }
            if let model = persistance.getDescriptonCharacter(name: name) {
                self.model = model
            }
            tableView.reloadData()
        }
    }
    // MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return model.episodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
        if indexPath.section == 0 {
            cell.initDetailCell(image: model.image, status: model.status, species: model.species, gender: model.gender, location: model.location, index: indexPath)
        } else {
            cell.initEpisodeDetailCell(model.episodes[indexPath.row])
        }
        return cell
    }
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRow(indexPath)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Episodes" : nil
    }
}
