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
    var model = [ListCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = GeneralPresenter(view: generalTableView, model: model, vc: self)
        generalTableView.dataSource = presenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.showCharacters()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueToDetailVC(segue: segue)
    }

    func segueToDetailVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "ShowDetail",
              let vc = segue.destination as? DetailVC,
              let index = generalTableView.indexPathForSelectedRow?.row else {return}
        vc.characterUrl = presenter.model[index].characterUrl
        vc.name = presenter.model[index].name
    }
}

extension GeneralVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
}
