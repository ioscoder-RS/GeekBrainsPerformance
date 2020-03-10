//
//  MessageCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 13/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var commentButton: CustomCommentButton!
    @IBOutlet weak var shareButton: CustomShareButton!
    @IBOutlet weak var viewedButton: CustomViewButton!
    @IBOutlet weak var newsPhoto: UICollectionView!
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        (sender as! LikeButton).like()

    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        (sender as! CustomCommentButton).comment()

    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        (sender as! CustomShareButton).share()
    }
    
    @IBAction func viewedButtonPressed(_ sender: Any) {
       (sender as! CustomViewButton).setLook()
    }
    
    var newsPhotocount: Int?
    var newsPhotoArray: [String]?

    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        self.newsPhoto.delegate = self
        self.newsPhoto.dataSource = self
    }
    
    func registerCell() {
        newsPhoto.register(UINib(nibName: "NewsPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsPhotoCell")
        
        //этот набор команд переопределяет FlowLayout.
        //если эти команды раскоментированы, то кастомный layout из storyBoard = NewsCellLayout не выполняется
//           let flowLayout = UICollectionViewFlowLayout()
//           flowLayout.scrollDirection = .horizontal
//           self.newsPhoto.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsPhotocount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsPhotoCell", for: indexPath) as? NewsPhotoCollectionViewCell else {
             return UICollectionViewCell()
         }
       
        if let image = newsPhotoArray?[indexPath.row] {
        cell.renderCell(imagePath:  image)
        }
   
        return cell
    }
    
    func renderCell(newsRecord: NewsForViewController, tableView: UITableViewController, row: Int, photoCashFunctions: PhotoCashFunctions){
    
        username.text = newsRecord.userName
        
        time.text = convertUnixTime(unixTime: newsRecord.newsDate)
        message.text = newsRecord.newsText
        likeButton.setLikeCount(likeCount: newsRecord.newsLikes.count, userLiked: newsRecord.newsLikes.userLikes)
        commentButton.setCommentCount(commentCount: newsRecord.newsComments.count, userCommented: 0)
        viewedButton.setViewedCount(viewedCount: newsRecord.newsViews.count, userViewed: 0)
        shareButton.setShareCount(shareCount: newsRecord.newsReposts.count, userShared: newsRecord.newsReposts.userReposted)
        
        if newsRecord.newsImages.count > 0
        {
        self.newsPhotocount = newsRecord.newsImages.count
        self.newsPhotoArray = newsRecord.newsImages
        }
        else
        {
            self.newsPhotocount = 0
            self.newsPhotoArray = []
        }
       
        print("В messagecell.rendercell распознали: username = \(newsRecord.userName) кол-во фото: \(newsRecord.newsImages.count)")
        
      //реализация загрузки изображения с использованием KingFisher
//        if let url = URL(string: newsRecord.avatarPath){   
//                     avatar.kf.setImage(with: url)
//        }
        
        //В качестве ДЗ использование "ручного" кэш c Promise
        photoCashFunctions.photo(urlString: newsRecord.avatarPath)
                       .done {[weak self] image in self?.avatar.image = image }
                       .catch { print($0)}
                
      newsPhoto.reloadData()
    }
    
}// class MessageCell

