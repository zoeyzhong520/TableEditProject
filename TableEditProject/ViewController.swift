//
//  ViewController.swift
//  TableEditProject
//
//  Created by zhifu360 on 2019/5/22.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    ///创建UITableView
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: BaseTableReuseIdentifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    ///数据源
    lazy var dataArray: [String] = {
        var tmpArr = [String]()
        for i in 0..<30 {
            tmpArr.append("\(i)")
        }
        return tmpArr
    }()
    
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setPage()
    }

    func setPage() {
        title = "演示"
        view.addSubview(tableView)
    }

    func setNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(btnAction(_:)))
    }
    
    @objc func btnAction(_ item: UIBarButtonItem) {
        if !isEditingMode {
            isEditingMode = true
            item.title = "完成"
        } else {
            isEditingMode = false
            item.title = "编辑"
        }
        //设置UITableView的模式
        tableView.isEditing = isEditingMode
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableReuseIdentifier, for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    @available(iOS 11, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //右滑置顶
        let actionTop = UIContextualAction(style: .normal, title: "置顶") { (action, view, finished) in
            //挪动cell
            let moveItem = self.dataArray[indexPath.row]
            self.dataArray.remove(at: indexPath.row)
            self.dataArray.insert(moveItem, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            finished(true)
        }
        //设置背景色
        actionTop.backgroundColor = UIColor.orange
        return UISwipeActionsConfiguration(actions: [actionTop])
    }
    
    @available(iOS 11, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //左滑删除
        let actionDel = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            //从数据源中删除
            self.dataArray.remove(at: indexPath.row)
            //删除这一行
            tableView.deleteRows(at: [indexPath], with: .fade)
            finished(true)
        }
        //设置背景色
        actionDel.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [actionDel])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //从数据源删除
            dataArray.remove(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //将要移动的数据
        let moveItem = dataArray[sourceIndexPath.row]
        dataArray.remove(at: sourceIndexPath.row)
        dataArray.insert(moveItem, at: destinationIndexPath.row)
    }
    
}

