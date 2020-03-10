//
//  GroupCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 03/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var localConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupname:UILabel!
    @IBOutlet weak var groupimage: UIImageView!
   
    
    func setAnimation() {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 12, options: [], animations: {
        self.groupimage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }, completion: {_ in UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 12, options: [], animations: {
        self.groupimage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) })
    })
}
    
    var delegate : CellImageTapDelegate?
    var tapGestureRecognizer = UITapGestureRecognizer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        tapGestureRecognizer.addTarget(self, action: #selector(self.imageTapped(gestureRecgonizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(gestureRecgonizer: UITapGestureRecognizer) {
        delegate?.tableCell(didClickedImageOf: self)
    }
    
    func renderCell(model: VKGroupRealm){
     
            let groupName = model.groupName
      
            groupname.text = groupName
            
        if let url = URL(string: model.avatarPath){
                groupimage.kf.setImage(with: url)
            }
    }
}// class GroupCell

class NewGroupCell: UITableViewCell {

    @IBOutlet weak var newgroupname:UILabel!
 
}
