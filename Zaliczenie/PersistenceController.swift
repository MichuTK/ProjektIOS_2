import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Zaliczenie")

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        deleteAllData()
        loadInitialData()
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func loadInitialData() {
        let context = container.viewContext
        let fetchRequestCustomer: NSFetchRequest<CustomerEntity> = CustomerEntity.fetchRequest()
        let fetchRequestProduct: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        let fetchRequestOrder: NSFetchRequest<OrderEntity> = OrderEntity.fetchRequest()

        do {
            let productCount = try context.count(for: fetchRequestProduct)
            let customerCount = try context.count(for: fetchRequestCustomer)
            let orderCount = try context.count(for: fetchRequestOrder)
            
            if productCount == 0 && customerCount == 0 && orderCount == 0{
                let user1 = CustomerEntity(context: context)
                user1.email = "user1@example.com"
                user1.password = "password1"

                let user2 = CustomerEntity(context: context)
                user2.email = "user2@example.com"
                user2.password = "password2"
            
                let product1 = ProductEntity(context: context)
                product1.name = "Product 1"
                product1.price = 9.99
                product1.priceEur = 2.29
                product1.image = UIImage(named: "product1")?.jpegData(compressionQuality: 1.0)

                let product2 = ProductEntity(context: context)
                product2.name = "Product 2"
                product2.price = 19.99
                product2.priceEur = 4.59
                product2.image = UIImage(named: "product2")?.jpegData(compressionQuality: 1.0)

                let product3 = ProductEntity(context: context)
                product3.name = "Product 3"
                product3.price = 29.99
                product3.priceEur = 6.89
                product3.image = UIImage(named: "product3")?.jpegData(compressionQuality: 1.0)

                let product4 = ProductEntity(context: context)
                product4.name = "Product 9"
                product4.price = 39.99
                product4.priceEur = 8.99
                product4.image = UIImage(named: "product4")?.jpegData(compressionQuality: 1.0)
                
                let order1 = OrderEntity(context: context)
                order1.id = UUID()
                order1.date = Date()
                order1.customer = user1
                order1.product = product1
                
                let order2 = OrderEntity(context: context)
                order2.id = UUID()
                order2.date = Date()
                order2.customer = user1
                order2.product = product3

                let order3 = OrderEntity(context: context)
                order3.id = UUID()
                order3.date = Date()
                order3.customer = user2
                order3.product = product3

                saveContext();
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteAllData() {
        let context = container.viewContext
        let entities = container.managedObjectModel.entities

        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            fetchRequest.includesPropertyValues = false

            do {
                let items = try context.fetch(fetchRequest) as! [NSManagedObject]
                for item in items {
                    context.delete(item)
                }
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
