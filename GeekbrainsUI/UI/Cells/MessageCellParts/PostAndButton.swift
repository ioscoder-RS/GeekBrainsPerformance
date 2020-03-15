//
//  PostAndButton.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class PostAndButton: UITableViewCell {

    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func renderCell(newstext: String){
        newsText.text = newstext
    }
    
}
