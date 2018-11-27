//
//  CategoryController.swift
//  WhatTODO
//
//  Created by Burak Fidan on 21.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryController {
    
    let realm=try! Realm()
    
    func saveObject(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error occured. \(error)")
        }

    }
    
    func updateObject(category: Category,categoryString: String,colorID:String){
        do{
            try realm.write {
                category.category=categoryString
                category.colorID=colorID
            }
        }catch{
            print("Error occured. \(error)")
        }
    }
    
    func deleteObject(object:Object){
        do{
            try realm.write {
                realm.delete(object)
            }
        }catch{
            print("Error occured. \(error)")
        }
    }
    
    func deleteAll() {
        do{
            try realm.write {
                realm.deleteAll()
            }
        }catch{
            print("Error occured. \(error)")
        }
    }
    
    func getUserDefault(key:String)->Any{
        return UserDefaults.standard.object(forKey: key) ?? 0
    }
    
    func setUserDefault(userValue:Any,key:String){
        UserDefaults.standard.set(userValue, forKey: key)
    }
}
