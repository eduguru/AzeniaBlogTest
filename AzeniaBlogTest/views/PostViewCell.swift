//
//  PostViewCell.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 11/06/2021.
//

import UIKit

class PostViewCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
