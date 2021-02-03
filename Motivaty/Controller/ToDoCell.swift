//
//  ToDoCell.swift
//  Motivaty
//
//  Created by Robert Pelka on 01/02/2021.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var streakImage: UIImageView!
    @IBOutlet weak var doneImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let view = bgView {
            view.layer.cornerRadius = 15
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
