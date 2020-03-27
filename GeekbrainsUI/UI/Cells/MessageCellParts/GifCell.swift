//
//  GifCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 18/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class GifCell: UITableViewCell {

    @IBOutlet  var gif: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(gifURL:String){
        guard let url = URL(string: gifURL ) else {return}

          gif.kf.setImage(with: url)
    }//func renderCell(iconURL:String)
}//class
