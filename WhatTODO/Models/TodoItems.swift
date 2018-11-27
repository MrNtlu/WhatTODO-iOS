//
//  TodoItems.swift
//  WhatTODO
//
//  Created by Burak Fidan on 16.11.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import RealmSwift

class TodoItems: Object{
    @objc dynamic var todo: String=""
    @objc dynamic var checked: Bool=false
}
