//
//  HomeTableViewCell.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/8/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import UIKit

class HomeTableViewCell : UITableViewCell {
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!    
    @IBOutlet weak var labelPlot: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
