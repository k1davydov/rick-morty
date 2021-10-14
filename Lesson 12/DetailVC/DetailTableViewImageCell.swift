//
//  DetailTableViewImageCell.swift
//  Lesson 12
//
//  Created by Kirill Davydov on 08.10.2021.
//

import UIKit

class DetailTableViewImageCell: UITableViewCell {
    @IBOutlet weak var bigImage: UIImageView!
    
    func initDetailCell (_ index: Int) {
        downloadImage(index+1, completion: { image in
            self.bigImage.image = image
        })
        self.selectionStyle = .none
    }
}
