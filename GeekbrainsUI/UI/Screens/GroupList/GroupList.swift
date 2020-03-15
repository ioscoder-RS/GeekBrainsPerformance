//
//  GroupList.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 03/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//



import UIKit
import RealmSwift

protocol GroupListView: class {
    func updateTable()
    func updateForObserver(deletions: [Int], insertions: [Int], modifications: [Int])
}

protocol CellImageTapDelegate {
    func tableCell(didClickedImageOf tableCell: GroupCell)
}

class GroupList: UITableViewController, CellImageTapDelegate/*, ImageViewPresenterSource*/ {
    
    var presenter: GroupsPresenter?
    var configurator: GroupsConfigurator?
    
    @IBOutlet weak var groupSearchBar: UISearchBar!
    
    var customRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        groupSearchBar.delegate = self //чтобы поиск отрабатывал
        
        self.configurator = GroupsConfiguratorImplementation()
        configurator?.configure(view: self)
        
        presenter?.viewDidLoad()
    }//viewdidload
    
    func tableCell(didClickedImageOf tableCell: GroupCell) {
        // функция вызывает анимацию сжимающейся иконки
        //из ячейки класса GroupCell, на которую нажали
        tableCell.setAnimation()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.groups.count
        return presenter?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as? GroupCell else{ return UITableViewCell()}
        guard let vkGroupRealm = presenter?.getVKGroupRealmAtIndex(indexPath: indexPath) else {return cell}
        
        cell.delegate = self
        cell.renderCell(model: vkGroupRealm)
        
        return cell
    } // override func tableView(_ tableView: UITableView, cellForRowAt
    
    //запускаем снег по нажатию соответствующей кнопки
    @IBOutlet weak var snowButton: UIBarButtonItem!
    @IBAction func snowButtonPressed(_ sender: Any) {
        let duration = 30.0
        let emitterSnow = EmitterSnow()
        
        emitterSnow.letItSnow(duration: duration, view: view)
        
        //делаем кнопку недоступной пока идет снег (= duration)
        self.snowButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.snowButton.isEnabled = true
        }
    }
    @IBAction func AddButtonPressed(_ sender: Any) {
        let l_count: Int = presenter?.numberOfRows() ?? 0
        array_append(name: "NewGroup\(l_count)", id: l_count)
    }
   
    //MARK: в будущем можно вызывать новости для конкретной группы
//    @IBAction func toGroupDetailButtonPressed(_ sender: Any) {
//        let animationDuration = 0.1
//        //     animationLoad(duration: animationDuration)
//
//        self.perform(#selector(navigateToViewController), with: nil, afterDelay: animationDuration)
//    }
//
//    @objc func navigateToViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(identifier: "SolidNewsViewController") as! SolidNewsViewController
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
    
    func array_append ( name: String, id: Int){
        //        groups.append(Group(groupName: name, avatarPath: "no", id: id))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell:
        UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    //Добавляем ф-л удаления строчки через UITableViewCell.EditingStyle
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete{
            //groupsResult.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func array_delete ( row: Int){
        // groups.remove(at: row)
        tableView.reloadData()
    }
    
    func addRefreshControl(){
        customRefreshControl.attributedTitle = NSAttributedString(string:"refreshing...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc func refreshTable(){
        //фейковая функция, имитирует обновление из интернета
        
        //функция DispatchQueue дает паузу в 3 сек...
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //... и закрывает refreshing
            self.customRefreshControl.endRefreshing()
        }
    }
    
}//class GroupList

extension GroupList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchGroups(name: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension GroupList: GroupListView {
    func updateTable() {
        tableView.reloadData()
    }
    
    func updateForObserver(deletions: [Int], insertions: [Int], modifications: [Int]){
        tableView.beginUpdates()
        tableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .none)
        tableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .none)
        tableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .none)
        tableView.endUpdates()
    }
}//extension


