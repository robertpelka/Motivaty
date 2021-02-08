//
//  ToDoCell.swift
//  Motivaty
//
//  Created by Robert Pelka on 08/02/2021.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var streakImage: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let background = bgView {
            background.layer.cornerRadius = 15
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
