//
//  IconUserTimeCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class IconUserTimeCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        // Initialization code
    }
   
    func renderCell(iconURL:String, newsAuthor: String, newsTime: String){
        
              let photoCashFunctions = PhotoCashFunctions()
        
        //заполняем иконку с использованием "ручного" кэша
        photoCashFunctions.photo(urlString: iconURL)
              .done {[weak self] image in self?.iconImage.image = image }
              .catch { print($0)}
        
        self.newsAuthor.text = newsAuthor
        self.newsTime.text = newsTime
        
    }
}
