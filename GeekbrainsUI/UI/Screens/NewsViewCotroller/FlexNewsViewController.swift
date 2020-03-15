//
//  NewsViewController.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit


protocol MessageView: class {
    func updateTable()
}

class FlexNewsViewController: UITableViewController{
    
    var presenter: NewsViewPresenter?
    var configurator: NewMessageViewConfigurator?

    override func viewDidLoad() {
        registerCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        self.configurator = NewMessageViewConfiguratorImplementation()
        configurator?.configure(view: self)
        
        presenter?.viewDidLoad()
    }
    
    private func registerCells(){
        tableView.register(UINib(nibName: "IconUserTimeCell", bundle: nil),forCellReuseIdentifier:"iconUserTimeCell")
        tableView.register(UINib(nibName: "PostAndButton", bundle: nil),forCellReuseIdentifier:"postAndButton")
        tableView.register(UINib(nibName: "LikesRepostsComments", bundle: nil),forCellReuseIdentifier:"likesRepostsComments")
        tableView.register(UINib(nibName: "PhotoCollectionTableViewCell", bundle: nil),forCellReuseIdentifier:"photoCollectionTableViewCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //должно возвращаться количество постов из презентер
        return presenter?.numberOfSections() ?? 0
    //    return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.getTableviewCell(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
    
    //Заглушка, задающая высоту ячейки, чтобы туда помещалась встроенная CollectionView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getRowHeight(tableView: tableView, indexPath: indexPath) ?? CGFloat(0)
    }
    
    
}// class MessageViewController

extension FlexNewsViewController: MessageView{
    func updateTable() {
        tableView.reloadData()
    }
}

extension FlexNewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        presenter?.fetchMoreNews(tableView: tableView, indexPaths: indexPaths)
    }
}
