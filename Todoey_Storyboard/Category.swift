//
//  Category.swift
//  Todoey_Storyboard
//
//  Created by hazem smawy on 9/3/22.
//

import Foundation
import RealmSwift

class Category :Object {
    @objc dynamic var name:String = ""
    var items = List<CategoryItem>()
}
