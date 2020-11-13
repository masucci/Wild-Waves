//
//  CustomTableViewCell.swift
//  Wild Waves
//
//  Created by Lorenzo on 12/11/2020.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellImage.layer.cornerRadius = cellImage.frame.size.width / 2
        cellImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ name: String, _ image: String) {
        cellLabel.text = name
        cellImage.image = UIImage(named: image)
    }
    
}
