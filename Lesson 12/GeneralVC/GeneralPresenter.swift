//
//  GeneralPresenter.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 16.11.2021.
//

import Foundation
import UIKit

class GeneralPresenter: NSObject, GeneralPresenterProtocol {
    unowned let view: UITableView
    var model: [RickMorty]
    
    required init(view: UITableView, model: [RickMorty]) {
        self.view = view
        self.model = model
    }
    
    func showCharacters(_ url: String) {
        downloadData(url) { rickMortys in
            let model = parserCharacters(rickMortys)
            self.model.append(contentsOf: model)
            
            for i in 0..<model.count {
                downloadImage(model[i].imageUrl) { image in
                    self.model[self.model.count-20+i].image = image
                    self.view.reloadData()
                }
            }
        }
    }
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == model.count-1, indexPath.row != 0, let next = generalNextPage {
            showCharacters(next)
        }
        
        let modelFinal = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralCell") as! GeneralTableViewCell
        cell.initGeneralCell(name: modelFinal.name, gender: modelFinal.gender, location: modelFinal.locationUrl, bigImage: modelFinal.image, status: modelFinal.status)
        return cell
    }
}
