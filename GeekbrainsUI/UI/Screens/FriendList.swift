//
//  FriendList.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit
import Kingfisher

struct Section<T>{
    var title: String
    var items: [T]
}

protocol FriendsListView: class{
    func updateTable()
}

class FriendList: UITableViewController, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var presenter: FriendsPresenter?
    var configurator: FriendsConfigurator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: пока здесь, т.к. нет больше вызовов
        //ViewController.configurator = FriendsConfiguratorImplementation()
        self.configurator = FriendsConfiguratorImplementation()
        
        configurator?.configure(view: self)
        searchBar.delegate = self
        presenter?.viewDidLoad()
    }// override func viewDidLoad()
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return presenter?.numberOfSections() ?? 0
    }
    
    
    //заполняем строки именем пользователя и, если получится, картинкой
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTemplate", for: indexPath) as? FriendCell,
            let vkUserRealm = presenter?.getVKUserRealmAtIndex(indexPath: indexPath)
            else{
                return UITableViewCell()
        }
        //настраиваем ячейку, фотографией и ФИО
        cell.renderCell(model: vkUserRealm)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vkUserRealm = presenter?.getVKUserRealmAtIndex(indexPath: indexPath) else {return}
        
        //Получаем фотки из Web  и переходим в след. ViewController
        presenter?.getPhotosByVKUserRealmAndGo(view: self, userRealm: vkUserRealm)
    }//override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return presenter?.getSectionIndexTitles()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        let label = UILabel()
        label.text = presenter?.getTitleForSection(section: section)
        label.frame = CGRect(x: 10, y: 2, width: 14, height: 15)
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
}// class FriendList

extension FriendList: FriendsListView{
    func updateTable() {
        tableView.reloadData()
    }
}

extension FriendList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchFriends(name: searchText)
    }//func searchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}//class FriendList

extension FriendList {
    @IBAction func logoutPressed(_ sender: Any)
    {
        Session.shared.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies
        {
                [weak self] cookies in cookies.forEach
                {
                        Session.shared.webView.configuration.websiteDataStore.httpCookieStore.delete($0)
                }//forEach
        }//completion getAllCookies
        
  
        var window: UIWindow?
        
        window = UIWindow(frame: CGRect(x:0,
                                        y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(identifier: "FirstScreen")
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        
        /* работает
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FirstScreen")
        */
        

//    self.navigationController?.dismiss(animated: true, completion: nil)
           //self.navigationController?.pushViewController(vc, animated: true)
        // vc.navigationController?.popToRootViewController(animated: true)
  //      vc.navigationController?.navigationController?.popViewController(animated: true)
    //    vc.navigationController?.navigationController?.popToRootViewController(animated: true)

    }//@IBAction func logoutPressed(_ sender: Any)
}//extension FriendList
