//
//  GeneralTableViewController.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 23.08.2021.
//

import UIKit

class GeneralTableViewController: UITableViewController {
    
    var rickMortys: [RickMorty] = []
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadData { downloadResult in
            self.rickMortys = downloadResult
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rickMortys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "General Cell") as! GeneralTableViewCell
        
        cell.name.text = rickMortys[indexPath.row].name
        
        cell.gender.text = rickMortys[indexPath.row].gender
        
        cell.lastLocation.text = rickMortys[indexPath.row].location
        
        downloadImage(url: rickMortys[indexPath.row].imageURL, completion: { image in
            cell.bigImage.image = image
        })
        
        cell.indicator.layer.cornerRadius = cell.indicator.frame.width/2
        if rickMortys[indexPath.row].status == "Alive" {cell.indicator.backgroundColor = .green
        } else {
            cell.indicator.backgroundColor = .red
        }
        cell.alive.text = rickMortys[indexPath.row].status
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailTableViewController
        vc.url = rickMortys[indexPath.row].characterURL
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: self)
    }
}
