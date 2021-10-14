//
//  DetailTableViewController.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 06.10.2021.
//

import UIKit
import Alamofire

class DetailTableViewController: UITableViewController {
    var character = Character()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadCharacter(index+1) { value in
            self.character = value
            self.navigationItem.title = self.character.name
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 4 : character.episodes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Episodes" : nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigImageCell") as! DetailTableViewImageCell
            
            cell.initDetailCell(index)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
        
        cell.initDetailCell(character: character, index: indexPath)
        
        return cell
    }
}
