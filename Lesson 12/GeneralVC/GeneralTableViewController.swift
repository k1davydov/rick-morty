//
//  GeneralTableViewController.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 23.08.2021.
//

import UIKit

class GeneralTableViewController: UITableViewController {
    
    var data = myData()
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadCharacters(generalUrl) { data in
            self.data = data
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.characters.count-1, indexPath.row != 0 {
            downloadCharacters(data.nextPage) { data in
                self.data.characters.append(contentsOf: data.characters)
                self.data.nextPage = data.nextPage
                self.tableView.reloadData()
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "General Cell") as! GeneralTableViewCell
        
        cell.initGeneralCell(data.characters[indexPath.row], index: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailVC",
              let vc = segue.destination as? DetailTableViewController,
              let index = self.tableView.indexPathForSelectedRow else {return}

        vc.index = index.row
    }
}
