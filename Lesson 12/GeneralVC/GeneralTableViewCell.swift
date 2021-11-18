//
//  GeneralTableViewCell.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 23.08.2021.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var alive: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var location: UILabel!
    
    func initGeneralCell(name: String, gender: String, location: String, bigImage: UIImage, status: (String, UIColor)) {
        self.selectionStyle = .none
        
        self.name.text = name
        self.gender.text = gender
        self.location.text = location
        self.bigImage.image = bigImage
        self.alive.text = status.0
        self.indicator.backgroundColor = status.1
        
        self.indicator.layer.cornerRadius = self.indicator.frame.width/2
    }
    
    func loadingData(_ state: Bool) {
        if state {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            contentView.isHidden = true
        } else {
            contentView.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}
