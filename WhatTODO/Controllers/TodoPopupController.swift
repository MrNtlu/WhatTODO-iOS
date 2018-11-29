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
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    var tableView: UITableView?
    var realm: Realm?
    var category: Category?
    var todoItem:TodoItems?
    var colorID:String?
    
    var mTodo:TodoItems?{
        didSet{
            todoItem=mTodo
        }
    }
    
    var mColorID:String?{
        didSet{
            colorID=mColorID
        }
    }
    
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
        if colorID != nil{
            self.popupView.backgroundColor=UIColor(hexString: colorID!)
        }
        if todoItem != nil{
            addButtonOutlet.setTitle("Update", for: .normal)
            whatTodoText.text=todoItem?.todo
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        do{
            try self.realm!.write {
                if self.todoItem == nil {
                    let newTodo=TodoItems()
                    newTodo.todo=whatTodoText.text!
                    newTodo.checked=false
                    category?.items.append(newTodo)
                }
                else if self.todoItem != nil{
                    self.todoItem!.todo=self.whatTodoText.text!
                }
                tableView?.reloadData()
            }
        }catch{
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
}
