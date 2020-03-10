//
//  ProfileController.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 20/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
 
    @IBOutlet weak var loginParams: UIButton!
    
    var mainTab = MainTab()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = mainTab.vkLogin?.id,
            let firstName = mainTab.vkLogin?.firstName,
            let lastName = mainTab.vkLogin?.lastName else {return}
    
        loginParams.setTitle(firstName + " " + lastName, for: .normal)
    }

}
