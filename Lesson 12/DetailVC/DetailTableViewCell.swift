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
    
    func initDetailCell(character: Character, index: IndexPath) {
        self.selectionStyle = .none
        if index.section == 0 {
            switch index.row {
            case 1:
                self.generalLabel.text = "Live status"
                self.descriptionLabel.text = character.status
            case 2:
                self.generalLabel.text = "Species and gender"
                self.descriptionLabel.text = "\(character.species)(\(character.gender))"
            default:
                self.generalLabel.text = "Last known location"
                self.descriptionLabel.text = character.location
            }
        } else {
            guard character.episodes[index.row] != "" else {
                self.descriptionLabel.text = nil
                return
            }
            downloadEpisode(character.episodes[index.row]) { result in
                self.generalLabel.text = result
                self.descriptionLabel.text = nil
            }
        }
    }
}
