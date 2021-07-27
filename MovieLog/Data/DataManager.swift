//
//  DataManager.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/26.
//

import Foundation
import CoreData

class DataManager {
  static let shared = DataManager()
  
  var mainContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  var reviewData = [Review]()
  
  func fetchReview() {
    let request: NSFetchRequest<Review> = Review.fetchRequest()
    let sortByDateDesc = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sortByDateDesc]
    
    do {
      reviewData = try mainContext.fetch(request)
    } catch {
      print(error)
    }
  }
  
  func addReview(
    _ title: String,
    _ date: Date,
    _ sliderValue: Double,
    _ intValue: Int,
    _ content: String,
    _ poster: String
  ) {
    let newReview = Review(context: mainContext)
    newReview.title = title
    newReview.date = date
    newReview.sliderValue = sliderValue
    newReview.content = content
    newReview.poster = poster
    newReview.intValue = Int16(intValue)
    reviewData.insert(newReview, at: 0)
    saveContext()
  }
  
  func deleteReview(_ review: Review?) {
    if let review = review {
      mainContext.delete(review)
      saveContext()
    }
  }
  
  func removeReview(at indexPath: IndexPath) {
    reviewData.remove(at: indexPath.item)
    saveContext()
  }
  
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ReviewData")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
