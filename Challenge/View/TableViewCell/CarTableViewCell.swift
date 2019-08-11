//
//  CarTableViewCell.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
