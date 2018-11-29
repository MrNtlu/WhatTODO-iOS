//
//  TodoController.swift
//  WhatTODO
//
//  Created by Burak Fidan on 16.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoController: UIViewController{
    let realm=try! Realm()

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoItems: Results<TodoItems>?
    var colorID:String?
    var defaultColor:String="34495E"
    var indexPathForEdit: Int?
    
    var selectedColor : String? {
        didSet{
            colorID=selectedColor
        }
    }
    
    var selectedCategory : Category?{
        didSet{
            todoItems=selectedCategory?.items.sorted(byKeyPath: "todo", ascending: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.searchBar.barTintColor=UIColor(hexString: colorID!)
        searchBar.delegate=self
        //Remove searchbar borders
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title=selectedCategory?.category
        TodoController.updateNavBar(withHexCode: colorID!,navBar: navigationController!)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        do{
            try self.realm.write {
                let newTodo=TodoItems()
                newTodo.todo="test1"
                newTodo.checked=false
                selectedCategory?.items.append(newTodo)
            }
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    static func updateNavBar(withHexCode colorHexCode: String,navBar: UINavigationController){
        let navBar=navBar.navigationBar
        let navBarColor=UIColor(hexString: colorHexCode)
        navBar.tintColor=ContrastColorOf(navBarColor!, returnFlat: true)
        navBar.barTintColor=navBarColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoPopupController
        destinationVC.mRealm=self.realm
        destinationVC.mCategory=self.selectedCategory
        destinationVC.mTableView=self.tableView
        destinationVC.mColorID=self.colorID
        if segue.identifier=="goTodoEdit"{
            destinationVC.mTodo=self.todoItems![self.indexPathForEdit!]
        }
    }
    
    func updateCheck(indexPath: IndexPath){
        do{
            try realm.write {
                todoItems![indexPath.row].checked = !todoItems![indexPath.row].checked
            }
        }catch{
            print("Error \(error)")
        }
    }
}
extension TodoController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell=tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        if todoItems![indexPath.row].checked {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else if !(todoItems![indexPath.row].checked){
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todoItems![indexPath.row].todo)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        updateCheck(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.categoryLabel.text=todoItems?[indexPath.row].todo
        cell.backgroundColor=UIColor(hexString: colorID!)
        cell.categoryLabel.textColor=UIColor.white
        if todoItems![indexPath.row].checked {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func editAction(at:IndexPath)->UIContextualAction{
        let action=UIContextualAction(style: .normal, title: "Edit") { (action, view, complation) in
            self.indexPathForEdit=at.row
            self.performSegue(withIdentifier: "goTodoEdit", sender: self)
            complation(true)
        }
        action.backgroundColor=UIColor.orange
        return action
    }
    
    func deleteAction(at:IndexPath)->UIContextualAction{
        let todoItem=todoItems![at.row]
        let action=UIContextualAction(style: .destructive, title: "Delete") { (action, view, complation) in
            var catCont=CategoryController()
            catCont.deleteObject(object: todoItem)
            self.tableView.reloadData()
        }
        action.backgroundColor=UIColor.red
        return action
    }
}
extension TodoController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems=todoItems!.filter("todo CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "category", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            todoItems!.sorted(byKeyPath: "todo", ascending: true)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
