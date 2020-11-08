//  MiniRemindersDataModel.swift
//  MiniReminders
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/5/2020 3:30

import Foundation

class MiniRemindersDataModel {
    
    // all reminders are stored in an instance variable
    var toDoList: [Item] = [
        Item(newContent: "Wash the dishes",
             newCategory: "Chore",
             newDate: Date(timeIntervalSinceNow: TimeInterval(0)))
    ]
    
    // setter method to add reminders
    func addEvent(content: String,
                  category: String,
                  dueDate: Date) {
        self.toDoList.append(Item(newContent: content,
                                  newCategory: category,
                                  newDate: dueDate))
    }
}

// class definition for one entry in the MiniReminders TODO list
class Item {
    // instance variables
    var content: String
    var category: String
    var date: Date
    var complete: Bool
    
    // constructor
    init(newContent: String, newCategory: String, newDate: Date) {
        self.content = newContent
        self.category = newCategory
        self.date = newDate
        self.complete = false
    }
}
