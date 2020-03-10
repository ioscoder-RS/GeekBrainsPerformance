import UIKit

class FriendCell : UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var myShadowView: CircleShadowImage!
    
    func renderCell(model: VKUserRealm) {
        let firstname = model.firstName
        let lastname =  model.lastName
        
        username.text = firstname + " " + lastname
        
        if let url = URL(string: model.avatarPath){
            userimage.kf.setImage(with: url)
        }
    }
}
