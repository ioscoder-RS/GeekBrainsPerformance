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
    
    func renderCell(iconURL:String){
        let imageLoadQueue = DispatchQueue(label: "GeekbrainsUI.gif.renderCell", attributes: .concurrent)
        
  
   
        
     imageLoadQueue.async {
            if iconURL != ""{
                let photoCashFunctions = PhotoCashFunctions()

                //заполняем иконку с использованием "ручного" кэша
                photoCashFunctions.photo(urlString: iconURL)
                    .done {[weak self] image in self?.gif.image = image }
                    .catch { print($0)}
            
//            let imageURL = UIImage.gifImageWithURL(iconURL)

//
//            let imageView3 = UIImageView(image: imageURL)
//               imageView3.frame = CGRect(x: 20.0, y: 390.0, width: self.gif.frame.size.width - 40, height: 150.0)
//        self.gif.addSubview(imageView3)
                
        }// if iconURL != ""{
      }//imageLoadQueue.async
    }//func renderCell(iconURL:String)
}//class
