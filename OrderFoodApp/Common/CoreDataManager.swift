//
//  CoreDataManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 09/10/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OrderFoodApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Fetch tasks
    func fetchTasks() -> [TaskModel] {
        let request: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    // Add task
    func addTask(title: String, image: String, desc: String, age: Int) {
        let newTask = TaskModel(context: context)
        newTask.title = title
        newTask.image = image
        newTask.desc = desc
        newTask.age = Int16(age)
        saveContext()
    }

    // Delete task
    func deleteTask(task: TaskModel) {
        context.delete(task)
        saveContext()
    }

    // Toggle task completion
    func toggleTaskCompletion(task: TaskModel) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    // Edit task
     func editTask(task: TaskModel, newTitle: String){
         task.title = newTitle
         saveContext()
     }
    
    // Fetch tasks
    func fetchTaskss() -> [PersonModel] {
        let request: NSFetchRequest<PersonModel> = PersonModel.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    

}

enum CoreDataResult {
    case added, failed, deleted, updated
}
