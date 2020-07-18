//
//  TableViewCell.swift
//  CIC
//
//  Created by Данила on 28.05.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var profitLabel:UILabel!
    @IBOutlet weak var oldCapital: UILabel!
    @IBOutlet weak var newCapital: UILabel!
    @IBOutlet weak var paysByYear: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
