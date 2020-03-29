//
//  SelfProfile.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class SelfProfile: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var openCameraButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(avatarPath:String){
        guard let url = URL(string: avatarPath ) else {return}

            profileImage.kf.setImage(with: url)
    }
}
