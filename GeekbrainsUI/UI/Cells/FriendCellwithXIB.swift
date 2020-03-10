//
//  FriendCellwithXIB.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 27/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class FriendCellwithXIB: UICollectionViewCell {

    @IBOutlet weak var friendsPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func refreshWith(friend: Friend){
        friendsPhoto.image = UIImage(named: "\(friend.avatarPath).jpg")
    }//
    
}//class FriendCellwithXIB: UICollectionViewCell
