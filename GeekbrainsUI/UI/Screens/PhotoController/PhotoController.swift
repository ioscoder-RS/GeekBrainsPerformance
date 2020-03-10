

import UIKit
import Kingfisher

private let reuseIdentifier = "PhotoCell"

protocol PhotoListView: class{
    
}

class PhotoController: UICollectionViewController, PhotoListView,  UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var presenter: FriendsPresenter?
    var configurator: PhotosConfigurator?
    
    var tmpVKUserRealm: VKUserRealm? //текущий элемент Друг типа структура, на котором стоим
    var tmpFriend: Friend?
    //   var viewClicked: ((UIView)->())? = nil
    //   var photoArray: [VKPhoto]?
    
    private var selectedFrame: CGRect? = .zero
    var customInteractor: CustomInteractor?
    var tmpImage: UIImage? // текущая картинка, на которой стоим
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tmpVKUserRealm = self.tmpVKUserRealm else {
            print ("error. tmpFriend is not initialised!")
            return
        }
        self.tmpFriend = convertFriend(user: tmpVKUserRealm.toModel())
        //       configurator?.configure(view: self, VKUserRealm: tmpVKUserRealm )
        
        self.navigationController?.delegate = self
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getPhotoControllerCount() ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let defaultUsername = tmpFriend!.userName
        
        guard let model = presenter?.getVKPhotoAtIndex(indexPath: indexPath) else {return cell}
        
        cell.renderCell(model: model, username: defaultUsername)
        
        tmpImage = cell.photo.image
        return cell
    }
    
    //вызывает экран MusicPlayerViewController
    //запоминает выбранную (песню = экземпляр структуры) и фрейм
    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //       self.selectedSong = songs[indexPath.row]
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
   //     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "FriendsPhotoViewController") as! FriendsPhotoViewController
        
        guard let localSizes = presenter?.getVKPhotoSizesAtIndex(indexPath: indexPath) else {return}
        let localLikes = presenter?.getVKPhotoLikesAtIndex(indexPath: indexPath)
        
        //передаем в след. ViewController ссылку на большую картинку
        //которая хранится в массиве sizes с типом X
        let urlToBe = localSizes.filter("type == %@","x")[0].url
        viewController.friend = tmpFriend
        viewController.imageURL = urlToBe
        viewController.likeCount = localLikes?.count
        viewController.userLiked = localLikes?.userLikes
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    

    //вызывает анимацию перехода
    //    We want to create a property that stores the frame of the selected cell.  In the didSelectItem function, we want to modify it a little bit so we grab the cells frame, but specifically the frame of the cell relative to that of the ViewController:
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
        guard let tmpimage = self.tmpImage else {return nil}
        
        //       Now we have the selectedFrame, and we can access the selected image from our array of songs, we’re finally ready to implement the CustomAnimator. Because we’ve inherited from UINavigationControllerDelegate, we can implement the method that is used to override the default animation.
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, originFrame: frame, image: tmpimage)
        default:
            return CustomAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, originFrame: frame, image: tmpimage)
        }
    }//func navigationController(_ navigationController: UINavigationController, animationControllerFor operation:
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        (sender as! LikeButton).like()
    }
    
}// class PhotoController

