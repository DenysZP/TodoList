//
//  CustomCell.swift
//  TodoList
//
//  Created by imac on 18.12.16.
//  Copyright © 2016 imac. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    //MARK: VIEW PROPERTIES
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
