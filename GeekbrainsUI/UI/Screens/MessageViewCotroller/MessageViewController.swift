//
//  MessageViewController.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 13/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

//3. Создать экран новостей. Добавить туда таблицу и сделать ячейку для новости. Ячейка должна содержать то же самое, что и в оригинальном приложении ВКонтакте: надпись, фотографии, кнопки «Мне нравится», «Комментировать», «Поделиться» и индикатор количества просмотров. Сделать поддержку только одной фотографии, которая должна быть квадратной формы и растягиваться на всю ширину ячейки. Высота ячейки должна вычисляться автоматически.

import UIKit


class NewsDatabase {
    static func getNews() -> [News]{
        return myNews
    }
}

protocol MessageView: class {
    func updateTable()
}

class MessageViewController: UITableViewController{
        
    var presenter: MessageViewPresenter?
    var configurator: MessageViewConfigurator?
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "SimpleMessage")
        
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.configurator = MessageViewConfiguratorImplementation()
              configurator?.configure(view: self)
              
              presenter?.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let photoCashFunctions = PhotoCashFunctions()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleMessage", for: indexPath) as? MessageCell else{ return UITableViewCell()}
        
        guard let currentNews = presenter?.getCurrentNewsAtIndex(indexPath: indexPath) else {return cell}
        
        cell.renderCell(newsRecord: currentNews, tableView: self, row: indexPath.row, photoCashFunctions: photoCashFunctions)
        
        return cell
    }
    
    //Заглушка, задающая высоту ячейки, чтобы туда помещалась встроенная CollectionView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
    
}// class MessageViewController

extension MessageViewController: MessageView{
    func updateTable() {
        tableView.reloadData()
    }
}
