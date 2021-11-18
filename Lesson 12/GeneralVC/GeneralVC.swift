//
//  GeneralVC.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import UIKit

class GeneralVC: UIViewController {
    @IBOutlet weak var generalTableView: UITableView!
    
    var presenter: GeneralPresenter!
    var model = [RickMorty]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = GeneralPresenter(view: generalTableView, model: model)
        generalTableView.dataSource = presenter
        generalTableView.delegate = self
        
        checkInternetConnection(self)
        presenter.showCharacters(generalUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkInternetConnection(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueToDetailVC(segue: segue)
    }

    func segueToDetailVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "ShowDetail",
              let vc = segue.destination as? DetailVC,
              let index = generalTableView.indexPathForSelectedRow?.row else {return}
        vc.model = presenter.model[index]
    }
}

extension GeneralVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
}
