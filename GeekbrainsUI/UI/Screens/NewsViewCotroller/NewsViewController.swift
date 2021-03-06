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
    func addSubView(view: UIView)
}

class NewsViewController: UITableViewController{
    
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
        tableView.register(UINib(nibName: "GifCell", bundle: nil),forCellReuseIdentifier:"gifCell")
        tableView.register(UINib(nibName: "LinkCell", bundle: nil),forCellReuseIdentifier:"linkCell")
        tableView.register(UINib(nibName: "SelfProfile", bundle: nil),forCellReuseIdentifier:"selfProfile")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.getTableviewCell(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getRowHeight(tableView: tableView, indexPath: indexPath) ?? CGFloat(0)
    }
}// class MessageViewController

extension NewsViewController: MessageView{
    func updateTable() {
        tableView.reloadData()
    }
    
    func addSubView(view: UIView){
        tableView.addSubview(view)
    }
    
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter?.fetchMoreNews(tableView: tableView, indexPaths: indexPaths)
    }
}
