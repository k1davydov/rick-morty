//
//  DetailVC.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 17.11.2021.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    
    var presenter: DetailPresenter!
    var characterUrl = ""
    var model = DescriptionCharacter(name: "", status: "", species: "", gender: "", location: "", episodes: [""], image: UIImage(systemName: "person")!)
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = DetailPresenter(tableView: detailTableView, model: model, vc: self)
        
        detailTableView.dataSource = presenter
        detailTableView.delegate = presenter
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.showCharacter(url: characterUrl, name: name)
    }
}
