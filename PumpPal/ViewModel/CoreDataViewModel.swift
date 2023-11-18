//
//  CoreDataViewModel.swift
//  PumpPal
//
//  Created by Om Shewale on 11/18/23.
//

//
//  Persistence.swift
//  Test
//
//  Created by Om Shewale on 11/14/23.
//

import CoreData

class CoreDataViewModel:ObservableObject {
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Data")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
    
    
    
    
        
        func getFood(forUser user: UserEntity, forDate date: String) -> [FoodItemEntity] {
            let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [user.username])
            
            do {
                let currentUser = try container.viewContext.fetch(userFetchRequest)
                if let cur_user = currentUser.first {
                    print(" \(String(describing: cur_user.username)) foodHistory has these many foodhistory entities \(String(describing: cur_user.foodHistory?.count))")
                    if let foodHistorySet=cur_user.foodHistory as? Set<FoodHistoryEntity>{
                        let filteredFoodHistory=foodHistorySet.filter{$0.date == date}
                        print("Size of foodItemHistory for date \(date) is \(filteredFoodHistory.count)")
                        return filteredFoodHistory.flatMap{$0.foodItem?.allObjects as? [FoodItemEntity] ?? []}
                    }
                }
            } catch{
                print("user not found")
            }
            return []
        }
        
        
        
        
        func saveFood(foodResponse: FoodResponse, forUser user: UserEntity, forDate date: String) {
            let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [user.username])
            
            do {
                let currentUser = try container.viewContext.fetch(userFetchRequest)
                if let cur_user = currentUser.first {
                    
                    do{
                        print("Found user: \(user.username ?? "Unknown username")")
                        let foodHistoryFetchRequest: NSFetchRequest<FoodHistoryEntity> = FoodHistoryEntity.fetchRequest()
                        foodHistoryFetchRequest.predicate=NSPredicate(format: "date == %@ AND user == %@", argumentArray: [date,cur_user])
                        let existingFoodHistoryEntities = try container.viewContext.fetch(foodHistoryFetchRequest)
                        
                        if let foodHistoryEntity = existingFoodHistoryEntities.first{
                            
                            associateFoodItems(with: foodResponse.foods,to:foodHistoryEntity)
                        }else{
                            let newFoodHistoryEntity = FoodHistoryEntity(context: container.viewContext)
                            newFoodHistoryEntity.date = date
                            newFoodHistoryEntity.user = cur_user
                            cur_user.addToFoodHistory(newFoodHistoryEntity)
                            associateFoodItems(with: foodResponse.foods, to: newFoodHistoryEntity)
                        }
                        try container.viewContext.save()
                        
                        print("Saved the foodHistory for date \(date)")
                    }
                    catch{
                        print("Error saving FoodHistoryEntity: \(error)")
                    }
                    
                } else {
                    print("User not found")
                }
            } catch {
                print("Error fetching user: \(error)")
            }
        }
        
        
        
        
        func associateFoodItems(with foodItems:[FoodItem], to foodHistoryEntity:FoodHistoryEntity) {
            for foodItem in foodItems{
                let newFoodItemEntity=FoodItemEntity(context: container.viewContext)
                newFoodItemEntity.foodName=foodItem.foodName
                newFoodItemEntity.calories=String(foodItem.calories)
                newFoodItemEntity.carbohydrates=foodItem.carbohydrates
                newFoodItemEntity.protein=foodItem.protein
                newFoodItemEntity.totalFat=foodItem.totalFat
                foodHistoryEntity.addToFoodItem(newFoodItemEntity)
            }
        }
        func saveContext() {
            let context = container.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
}
