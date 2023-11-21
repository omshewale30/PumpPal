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
    @Published var fetchedFood: [FoodItemEntity] = []
    init() {
        container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error{
                print("Error loading coredata \(error)")
            }
            else{
                print("Successfully loaded core data")
            }
        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
   func authenticateUser(forUser userName :String,pass:String) -> Bool{
            
            let fetchRequest : NSFetchRequest<UserEntity>=UserEntity.fetchRequest()
            fetchRequest.predicate=NSPredicate(format: "username == %@", userName)
    
            do {
                let users = try container.viewContext.fetch(fetchRequest)
                if let user = users.first, user.password == pass {
                    return true
    
                } else {
                    // Display an authentication error message
                    print("Authentication failed. Incorrect username or password.")
                }
            } catch {
                // Handle the error
                print("Error fetching user: \(error.localizedDescription)")
            }
       return false
    }
    
    
    
       func addItem(userName:String,pass:String) -> Bool {

            let newItem = UserEntity(context: container.viewContext)
            newItem.username=userName
            newItem.password=pass
                
            do {
                try container.viewContext.save()
                print("User \(newItem.username) saved")
                return true
            } catch {
                let nsError = error as NSError
                return false
           
            }
        }
    func fetchFoodHistory(forUser user:UserEntity) -> [FoodItemEntity]{
        let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [user.username])
        do{
            let userResponse=try container.viewContext.fetch(userFetchRequest)
            if let cur_user=userResponse.first{
                if let foodHistorySet=cur_user.foodHistory as? Set<FoodHistoryEntity>{
                    print("Size of foodItemHistory is \(foodHistorySet.count)")
                    return foodHistorySet.flatMap{$0.foodItem?.allObjects as? [FoodItemEntity] ?? []}
                }
            }
        }catch{
            print("Couldnt fetch foodHistoryItem")
        }
        return []
        
    }
    
        
        func getFood(forUser user: UserEntity, forDate date: String) {
            let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [user.username])
            
            do {
                let currentUser = try container.viewContext.fetch(userFetchRequest)
                if let cur_user = currentUser.first {
                    print(" \(String(describing: cur_user.username)) foodHistory has these many foodhistory entities \(String(describing: cur_user.foodHistory?.count))")
                    if let foodHistorySet=cur_user.foodHistory as? Set<FoodHistoryEntity>{
                        let filteredFoodHistory=foodHistorySet.filter{$0.date == date}
                        print("Size of foodItemHistory for date \(date) is \(filteredFoodHistory.count)")
                       fetchedFood = filteredFoodHistory.flatMap{$0.foodItem?.allObjects as? [FoodItemEntity] ?? []}
                    }
                }
            } catch{
                print("user not found")
            }
        }

    func saveFood(foodResponse: FoodResponse, forUser user: UserEntity, forDate date: String, atLatitude lat: Double, atLongitude long:Double) {
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
                            
                            associateFoodItems(with: foodResponse.foods,to:foodHistoryEntity, atLatitude: lat,atLongitude: long )
                        }else{
                            let newFoodHistoryEntity = FoodHistoryEntity(context: container.viewContext)
                            newFoodHistoryEntity.date = date
                            newFoodHistoryEntity.user = cur_user
                            cur_user.addToFoodHistory(newFoodHistoryEntity)
                            associateFoodItems(with: foodResponse.foods, to: newFoodHistoryEntity, atLatitude: lat,atLongitude: long )
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
        
        
        
        
        func associateFoodItems(with foodItems:[FoodItem], to foodHistoryEntity:FoodHistoryEntity, atLatitude lat: Double, atLongitude long:Double) {
            for foodItem in foodItems{
                let newFoodItemEntity=FoodItemEntity(context: container.viewContext)
                newFoodItemEntity.foodName=foodItem.foodName
                newFoodItemEntity.calories=String(foodItem.calories)
                newFoodItemEntity.carbohydrates=foodItem.carbohydrates
                newFoodItemEntity.protein=foodItem.protein
                newFoodItemEntity.totalFat=foodItem.totalFat
                newFoodItemEntity.latitude = lat
                newFoodItemEntity.longitude = long
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
