//
//  ViewController.swift
//  WhatTODO
//
//  Created by Burak Fidan on 15.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import Toast_Swift

class ViewController: UITableViewController {
    
    let realm=try! Realm()
    
    var categories: Results<Category>!
    
    var categoryCont=CategoryController()
    
    var sortKey: String="sortControl"
    
    var indexPathForEdit: Int?
    
    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    
    @IBAction func sortButton(_ sender: Any) {
        if categoryCont.getUserDefault(key: sortKey) as! Int == 1 {
            sortButtonOutlet.image = UIImage(named: "sort_reverse")
            categoryCont.setUserDefault(userValue: 2, key: sortKey)
            loadCategory()
        }else if categoryCont.getUserDefault(key: sortKey) as! Int == 2{
            sortButtonOutlet.image = UIImage(named: "sort_alp")
            categoryCont.setUserDefault(userValue: 1, key: sortKey)
            loadCategory()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAll()
        if categoryCont.getUserDefault(key: sortKey) as! Int == 1{
            sortButtonOutlet.image = UIImage(named: "sort_alp")
        }
        else if categoryCont.getUserDefault(key: sortKey) as! Int == 2{
            sortButtonOutlet.image = UIImage(named: "sort_reverse")
        }
        else{
            categoryCont.setUserDefault(userValue: 1, key: sortKey)
        }
        loadCategory()
        self.tableView.delegate=self
        tableView.dataSource=self
        searchBar.delegate=self
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        if let category=categories?[indexPath.row]{
            cell.categoryLabel.textColor=UIColor.white
            cell.categoryLabel.text=category.category
            cell.backgroundColor=UIColor(hexString: category.colorID)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func editAction(at:IndexPath)->UIContextualAction{
        let action=UIContextualAction(style: .normal, title: "Edit") { (action, view, complation) in
            self.indexPathForEdit=at.row
            self.performSegue(withIdentifier: "goToEditPopup", sender: self)
            complation(true)
        }
        action.backgroundColor=UIColor.orange
        return action
    }
    
    func deleteAction(at:IndexPath)->UIContextualAction{
        let mCategory=categories[at.row]
        let action=UIContextualAction(style: .destructive, title: "Delete") { (action, view, complation) in
            self.categoryCont.deleteObject(object: mCategory)
            self.tableView.reloadData()
        }
        action.backgroundColor=UIColor.red        
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTodo" {
            let destinationVC=segue.destination as! TodoController
            
            if let indexPath=tableView.indexPathForSelectedRow{
                destinationVC.selectedColor = categories?[indexPath.row].colorID
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
        else if segue.identifier == "openPopUp"{
            let destinationVC=segue.destination as! PopupController
            destinationVC.mTableview=self.tableView
        }else if segue.identifier=="goToEditPopup"{
            let destinationVC=segue.destination as! PopupController
            destinationVC.mTableview=self.tableView
            destinationVC.mCategory=categories[indexPathForEdit!]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TodoController.updateNavBar(withHexCode: "34495E", navBar: navigationController!)
    }
    
    func loadCategory(){
        if categoryCont.getUserDefault(key: sortKey) as! Int == 2 {
            categories=realm.objects(Category.self).sorted(byKeyPath: "category", ascending: false)
        }
        else{
            categories=realm.objects(Category.self).sorted(byKeyPath: "category", ascending: true)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadCategory()
        categories=categories.filter("category CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "category", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadCategory()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
