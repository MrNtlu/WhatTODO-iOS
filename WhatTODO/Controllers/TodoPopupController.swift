//
//  TodoPopupController.swift
//  WhatTODO
//
//  Created by Burak Fidan on 26.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import RealmSwift
import Toast_Swift

class TodoPopupController: UIViewController{
    
    @IBOutlet weak var whatTodoText: UITextField!
    
    var tableView: UITableView?
    var realm: Realm?
    var category: Category?
    
    var mCategory:Category?{
        didSet{
            category=mCategory
        }
    }
    var mRealm:Realm?{
        didSet{
            realm=mRealm
        }
    }
    var mTableView:UITableView?{
        didSet{
            tableView=mTableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        do{
            try self.realm!.write {
                let newTodo=TodoItems()
                newTodo.todo=whatTodoText.text!
                newTodo.checked=false
                category?.items.append(newTodo)
                tableView?.reloadData()
            }
        }catch{
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
}
