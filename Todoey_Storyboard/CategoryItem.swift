//
//  CategoryItem.swift
//  Todoey_Storyboard
//
//  Created by hazem smawy on 9/3/22.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
   
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dataCreatedAt:Date?
    var  parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
