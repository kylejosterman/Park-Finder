//
//  ParkTableViewCell.swift
//  Park Finder
//
//  Created by Kyle Osterman on 3/27/21.
//

import UIKit

protocol TableViewTapped {
    func onClickCell(index: Int)
}

class ParkTableViewCell: UITableViewCell {
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
}
