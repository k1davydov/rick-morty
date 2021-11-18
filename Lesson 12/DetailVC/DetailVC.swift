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
    var model = RickMorty(name: "", status: ("", .systemBackground), species: "", gender: "", image: UIImage(), episodeUrl: NSArray(), imageUrl: "", locationUrl: "", characterUrl: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = model.name
        
        presenter = DetailPresenter(tableView: detailTableView, model: model)
        
        detailTableView.dataSource = presenter
        detailTableView.delegate = presenter
        
        detailTableView.reloadData()
        
        checkInternetConnection(self)
        presenter.episodesLoader()
    }
}
