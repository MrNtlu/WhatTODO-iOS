//
//  Categories.swift
//  WhatTODO
//
//  Created by Burak Fidan on 16.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import RealmSwift

class Category: Object{
    @objc dynamic var category: String=""
    @objc dynamic var colorID: String=""
    let items=List<TodoItems>()
}
