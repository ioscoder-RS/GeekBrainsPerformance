//
//  FriendsPhotoViewController.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 27/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit
import Kingfisher

class FriendsPhotoViewController : UIViewController {
    
    @IBOutlet weak var friendPhotolikeButton: LikeButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    
    
    
    public var friend : Friend?
    public var imageURL: String?
    public var likeCount: Int?
    public var userLiked:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageURL = self.imageURL else {return}
    
        if let friend = self.friend {
            guard let url = URL(string: imageURL ) else {return}
  //          print(url)
            friendPhoto.kf.setImage(with: url)
            username.text = friend.userName
            friendPhotolikeButton.setLikeCount(likeCount: self.likeCount ?? 0, userLiked: self.userLiked ?? 0)
            
            }
        
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        (sender as! LikeButton).like()
    }
    
}// class FriendsPhotoViewController

