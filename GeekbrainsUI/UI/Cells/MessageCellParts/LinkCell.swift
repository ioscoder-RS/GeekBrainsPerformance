//
//  LinkCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 23/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell {

   
    @IBOutlet weak var linkPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var linkCaption: UITextView!
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var linkPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(strLink: StrLink){
        //текст новости
        linkTitle.text = strLink.title
        
        //заголовок новости и ссылка
        linkCaption.isEditable = false
        
        var localLinkCaption: String
        //заглушка для link с пустым caption и заполненным URL
        if strLink.caption == "" {
            localLinkCaption = strLink.title
            linkTitle.isHidden = true //чтобы две одинаковые строки не выводить
        }else
        {
            localLinkCaption = strLink.caption
            linkTitle.isHidden = false
        }

        guard localLinkCaption != ""  else {return}
        
        //устанавливаем заголовок и адрес гиперссылки
        let attributedString = NSMutableAttributedString(string:  localLinkCaption)
        attributedString.addAttribute(.link, value: strLink.url, range: NSRange(location: 0, length: localLinkCaption.count))
        //присваиваем получекнную форматированную строку нашему   TextView
        linkCaption.attributedText = attributedString
        
        //настраиваем фото
         let photo = strLink.photo
        guard photo != "" else {
            linkPhotoConstraint.constant = 0
            return
        }
        //берем фото с учетом кэша
        let photoCashFunctions = PhotoCashFunctions()
        photoCashFunctions.photo(urlString: photo)
            .done {[weak self] image in self?.linkPhoto.image = image }
            .catch { print($0)}
       
    }//renderCell
}//class
