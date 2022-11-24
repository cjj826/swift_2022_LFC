import UIKit
import CoreData

class UserInfo{
    var usersCollection = [NSManagedObject]()
    
    private let persitentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LingFengClub")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("here we get the container!!!")
        return container
    }()
    
    init() {
        //拿出上下文
        let managedContext = persitentContainer.viewContext
        
        //一个个抓取
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            //结果赋给前端容器
            usersCollection = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("can not catch.\(error), \(error.userInfo)")
        }
        if (usersCollection.isEmpty) {
            print("this is the first time for start!!!")
            init_user()
        }
    }
    
    func saveUser() {
        let managedContext = persitentContainer.viewContext //拿出文本
        
        //如果文本有变化再保存
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch{
                let nsError = error as NSError
                print("error in saving data!", nsError.localizedDescription)
            }
        }
    }
    
    func addUser(name: String, age: Int32, sex: String, job: String, photo: String, id: String, passwd: String, worktime: Int32) -> User {
        let managedContext = persitentContainer.viewContext
        //新建一个实体
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        //将实体插入上下文
        let theUser = NSManagedObject(entity: entity, insertInto: managedContext)
        //初始化user
        theUser.setValue(name, forKey: "name")
        theUser.setValue(age, forKey: "age")
        theUser.setValue(sex, forKey: "sex")
        theUser.setValue(job, forKey: "job")
        theUser.setValue(photo, forKey: "photo")
        theUser.setValue(id, forKey: "id")
        theUser.setValue(passwd, forKey: "passwd")
        theUser.setValue(worktime, forKey: "worktime")
        //将实体放入字典中
        usersCollection.append(theUser)
        saveUser() //目前是只要修改就会存储到coredata中，这样避免忘记存储，但又可能有性能问题
        return theUser as! User //强制转型为Student
    }
    
    func delUser(theuser: User) {
        if let index = usersCollection.firstIndex(of: theuser) {
            //从前端中删除
            usersCollection.remove(at: index)
            //从后端中删除
            let managedContext = persitentContainer.viewContext
            managedContext.delete(theuser)
            saveUser()
        }
    }
    
    func trans(from : Int, to : Int) {
        let theuser = usersCollection[from]
        usersCollection.remove(at: from)
        usersCollection.insert(theuser, at: to)
    }
    
    func init_user() {
        var user = addUser(name: "李书实", age: 23, sex: "男", job: "社长", photo: "李书实", id: "1", passwd: "123", worktime: 0)
        user = addUser(name: "李嘉豪", age: 20, sex: "男", job: "副社长", photo: "李嘉豪", id: "2", passwd: "123", worktime: 0)
        user = addUser(name: "林语诚", age: 20, sex: "男", job: "副社长", photo: "林语诚", id: "3", passwd: "123", worktime: 0)
        user = addUser(name: "王雨帆", age: 19, sex: "女", job: "办公室部长", photo: "王雨帆", id: "4", passwd: "123", worktime: 0)
        user = addUser(name: "刘士群", age: 19, sex: "男", job: "办公室副部长", photo: "刘士群", id: "5", passwd: "123", worktime: 0)
        user = addUser(name: "贺若芸", age: 19, sex: "女", job: "财务", photo: "贺若芸", id: "6", passwd: "123", worktime: 0)
        user = addUser(name: "王翰琪", age: 20, sex: "男", job: "论坛管理员", photo: "王翰琪", id: "7", passwd: "123", worktime: 0)
        user = addUser(name: "武阿传", age: 19, sex: "男", job: "训练部部长", photo: "武阿传", id: "8", passwd: "123", worktime: 0)
        user = addUser(name: "叶晋希", age: 20, sex: "男", job: "训练部副部长", photo: "叶晋希", id: "9", passwd: "123", worktime: 0)
        user = addUser(name: "林恒毅", age: 19, sex: "男", job: "野外部部长", photo: "林恒毅", id: "10", passwd: "123", worktime: 0)
        user = addUser(name: "邓闽", age: 19, sex: "女", job: "野外部副部长", photo: "邓闽", id: "11", passwd: "123", worktime: 0)
        user = addUser(name: "龚翼辉", age: 19, sex: "男", job: "野外部副部长", photo: "龚翼辉", id: "12", passwd: "123", worktime: 0)
        user = addUser(name: "刘璐", age: 19, sex: "女", job: "装备部部长", photo: "刘璐", id: "13", passwd: "123", worktime: 0)
        user = addUser(name: "刘温慧", age: 19, sex: "女", job: "装备部副部长", photo: "刘温慧", id: "14", passwd: "123", worktime: 0)
        user = addUser(name: "王光瀚", age: 19, sex: "男", job: "装备部副部长", photo: "王光瀚", id: "15", passwd: "123", worktime: 0)
        user = addUser(name: "王仕轩", age: 19, sex: "男", job: "外联部部长", photo: "王仕轩", id: "16", passwd: "123", worktime: 0)
        user = addUser(name: "陈泊霖", age: 19, sex: "男", job: "外联部副部长", photo: "陈泊霖", id: "17", passwd: "123", worktime: 0)
        user = addUser(name: "江澍", age: 19, sex: "女", job: "宣传部部长", photo: "江澍", id: "18", passwd: "123", worktime: 0)
        user = addUser(name: "张晴", age: 19, sex: "女", job: "宣传部副部长", photo: "张晴", id: "19", passwd: "123", worktime: 0)
        print(user)
    }
    
}
