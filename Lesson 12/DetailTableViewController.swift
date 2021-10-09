//
//  DetailTableViewController.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 06.10.2021.
//

import UIKit
import Alamofire

class DetailTableViewController: UITableViewController {
    
    var url = ""
    var character = RickMorty()
    var episodes = [Episodes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request(url).validate().responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                guard let result = value as? NSDictionary,
                      let final = RickMorty(result) else {return}
                self.character = final
                self.navigationItem.title = self.character.name
                
                
                for element in self.character.episodes {
                    print(element)
                    guard let url = element as? String else {return}
                    AF.request(url).validate().responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            guard let result = value as? NSDictionary,
                                  let final = Episodes(result) else {return}
                            self.episodes.append(final)
                            self.tableView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        section == 0 ? 4 : episodes.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Episodes" : nil
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
            cell.descriptionLabel.text = "\(episodes[indexPath.row].name) - \(episodes[indexPath.row].episode)"
            cell.generalLabel.text = nil
            cell.selectionStyle = .none
            return cell
        }
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigImageCell") as! DetailTableViewImageCell
            downloadImage(url: character.imageURL, completion: { image in
                cell.bigImage.image = image
            })
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
            cell.descriptionLabel.text = "Live status"
            cell.generalLabel.text = character.status
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
            cell.descriptionLabel.text = "Species and gender"
            cell.generalLabel.text = "\(character.species)(\(character.gender))"
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
            cell.descriptionLabel.text = "Last known location"
            cell.generalLabel.text = character.location
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}
