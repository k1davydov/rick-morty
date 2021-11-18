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
    var model: RickMorty
    var episodes = [String]()
    
    required init(tableView: UITableView, model: RickMorty) {
        self.tableView = tableView
        self.model = model
    }
    func episodesLoader() {
        downloadEpisodes(model.episodeUrl) { episode in
            self.episodes.append(episode)
            self.tableView.reloadData()
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
            return episodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
        if indexPath.section == 0 {
            cell.initDetailCell(image: model.image, status: model.status.0, species: model.species, gender: model.gender, location: model.locationUrl, index: indexPath)
        } else {
            cell.initEpisodeDetailCell(episodes[indexPath.row])
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
