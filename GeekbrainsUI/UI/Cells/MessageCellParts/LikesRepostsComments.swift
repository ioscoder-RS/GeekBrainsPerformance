//
//  LikesRepostsComments.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class LikesRepostsComments: UITableViewCell {

    @IBOutlet weak var shareButton: CustomShareButton!
       @IBOutlet weak var commentButton: CustomCommentButton!
    @IBOutlet weak var viewButton: CustomViewButton!
    @IBOutlet weak var likeButton: LikeButton!
    
    
    @IBOutlet weak var stackView: UIStackView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = contentView.bounds
    }
    
    func renderCell(likesNews: LikesNews,
                    repostsNews: RepostsNews,
                    viewsNews: ViewsNews,
        commentsNews: CommentsNews){
        
        likeButton.setLikeCount(likeCount: likesNews.count, userLiked: likesNews.userLikes)
        commentButton.setCommentCount(commentCount: commentsNews.count, userCommented: 0)
        viewButton.setViewedCount(viewedCount: viewsNews.count, userViewed: 0)
        shareButton.setShareCount(shareCount: repostsNews.count, userShared: repostsNews.userReposted)
    }
}
