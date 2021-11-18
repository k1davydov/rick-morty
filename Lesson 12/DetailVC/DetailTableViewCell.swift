//
//  DetailTableViewCell.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 06.10.2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var generalLabel: UILabel!
    
    func initDetailCell(image: UIImage, status: String, species: String, gender: String, location: String, index: IndexPath) {
        self.selectionStyle = .none
        generalLabel.isHidden = false
        if let imageView = self.viewWithTag(100) {
            imageView.removeFromSuperview()
        }
        
        switch index.row {
        case 0:
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 350))
            imageView.backgroundColor = .systemBackground
            imageView.image = image
            imageView.tag = 100
            imageView.contentMode = .scaleAspectFill
            self.addSubview(imageView)
        case 1:
            
            generalLabel.text = status
            descriptionLabel.text = "Live status"
        case 2:
            generalLabel.text = "\(species) (\(gender))"
            descriptionLabel.text = "Species and gender"
        case 3:
            generalLabel.text = location
            descriptionLabel.text = "Last known location"
        default:
            generalLabel.text = "Error"
            descriptionLabel.text = "Error of loading"
        }
    }
    
    func initEpisodeDetailCell(_ episode: String) {
        self.selectionStyle = .none
        if let imageView = self.viewWithTag(100) {
            imageView.removeFromSuperview()
        }
        
        generalLabel.isHidden = true
        descriptionLabel.text = episode
    }
}
