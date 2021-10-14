//
//  GeneralTableViewCell.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 23.08.2021.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var alive: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var lastLocation: UILabel!
    
    func initGeneralCell(_ data: RickMorty, index: IndexPath) {
        self.name.text = data.name
        
        self.gender.text = data.gender
        
        self.lastLocation.text = data.location
        
        downloadImage(index.row + 1, completion: { image in
            self.bigImage.image = image
        })
        
        self.indicator.layer.cornerRadius = self.indicator.frame.width/2
        if data.status == "Alive" {
            self.indicator.backgroundColor = .green
        } else {
            self.indicator.backgroundColor = .red
        }
        self.alive.text = data.status
    }
    
}
