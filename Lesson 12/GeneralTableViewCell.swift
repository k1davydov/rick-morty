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
}
