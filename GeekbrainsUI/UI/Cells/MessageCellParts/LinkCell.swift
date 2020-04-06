//
//  LinkCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 23/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit
import Kingfisher

class LinkCell: UITableViewCell {

   
 
    @IBOutlet weak var linkCaption: UITextView!
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var linkPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

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
        if strLink.caption.isEmpty {
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
        
        //проверяем есть ли фото, иначе - возвращаем 0 высоту
         let photo = strLink.photo
        guard photo != "" else {
            NSLayoutConstraint.activate([
            linkPhoto.heightAnchor.constraint(equalToConstant: 0)
            ])
            return
        }
        //берем фото с учетом кэша
        guard let url = URL(string: photo ) else {return}
        linkPhoto.kf.setImage(with: url)
       
        //рендеринг видимых элементов
        let mainView = LinkCellUIView(label: linkTitle, textView: linkCaption, imageView: linkPhoto)
        self.contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        
    }//renderCell
}//class

class LinkCellUIView: UIView {
    init(label: UILabel, textView: UITextView, imageView: UIImageView) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(textView)
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            //т.к. картинка загрузится позже, цепляемся к верхнему краю: высота картинки + отступ
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 145),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
