//
//  ToDoCell.swift
//  Motivaty
//
//  Created by Robert Pelka on 01/02/2021.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var cellView: ToDoCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
