//
//  PopupController.swift
//  WhatTODO
//
//  Created by Burak Fidan on 21.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class PopupController: UIViewController {

    @IBOutlet weak var categoryNameText: UITextField!
    
    @IBOutlet weak var colorPicker: UISegmentedControl!
    
    @IBOutlet weak var addButton: UIButton!
    
    var tableView: UITableView?
    var categoryObject:Category?
    
    var categoryCont=CategoryController()
    
    var mCategory:Category?{
        didSet{
            categoryObject=mCategory
        }
    }
    
    var mTableview : UITableView? {
        didSet{
            tableView=mTableview
        }
    }
    
    var colorArray=[UIColor(named: "blue"),
                    UIColor(named: "red"),
                    UIColor(named: "yellow"),
                    UIColor(named: "green"),
                    UIColor(named: "orange"),
                    UIColor.black]
    
    @IBAction func addButtonAction(_ sender: Any) {
        if categoryObject != nil {
            categoryCont.updateObject(category: categoryObject!, categoryString: categoryNameText.text!, colorID: (colorArray[colorPicker.selectedSegmentIndex])!.hexValue())
            mTableview?.reloadData()
            dismiss(animated: true, completion: nil)
        }
        else{
            let newCategory=Category()

            if let colorHex=((colorArray[colorPicker.selectedSegmentIndex])?.hexValue()){
                newCategory.colorID=colorHex
                if categoryNameText.text?.trimmingCharacters(in: .whitespaces) != ""{
                    newCategory.category=categoryNameText.text!
                    categoryCont.saveObject(category: newCategory)
                    tableView?.reloadData()
                    dismiss(animated: true, completion: nil)
                }
                else{
                    self.view.makeToast("Please don't leave it empty!")
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if categoryObject != nil{
            categoryNameText.text=categoryObject?.category
            addButton.setTitle("Update", for: .normal)
            
        }
    }


}
