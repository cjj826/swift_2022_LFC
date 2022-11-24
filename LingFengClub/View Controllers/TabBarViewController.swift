import UIKit
import CoreData

class TabBarViewController : UITabBarController {
    
    let persitentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LingFengClub")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var id: String = ""
    
    var user: NSManagedObject? = nil
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("加载tableBar")
        print("get the id is \(id)!!!")
        //拿出数据库上下文
        let managedContext = persitentContainer.viewContext
        print(managedContext)
        //条件抓取实体
        let fetchUser = NSFetchRequest<User>(entityName: "User")
        
        fetchUser.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let users = try managedContext.fetch(fetchUser)
            self.user = users[0]
            print(users[0])
            print(self.user)
        } catch {
            print("error")
        }
    }
    
}
