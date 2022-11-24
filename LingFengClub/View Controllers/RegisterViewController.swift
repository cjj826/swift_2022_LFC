import UIKit
import CoreData

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
    
    
    @IBOutlet var id: UITextField!

    @IBOutlet var passwd: UITextField!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var age: UITextField!
    
    @IBOutlet var sex: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        if id.text == "" || passwd.text == "" || name.text == "" || age.text == "" || sex.text == "" {
            let alertControl : UIAlertController = UIAlertController(title: "警告框", message: "输入内容不能为空", preferredStyle: UIAlertController.Style.alert)
            let delAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertControl.addAction(delAction)
            self.present(alertControl, animated:true)
            return;
        }
        let id = id.text!
        //验证id是否重复
        let managedContext = persitentContainer.viewContext
        //条件抓取实体
        let fetchUser = NSFetchRequest<User>(entityName: "User")
        fetchUser.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let users = try managedContext.fetch(fetchUser)
            if (!users.isEmpty) {
                print("账号已注册！")
                let alertControl : UIAlertController = UIAlertController(title: "警告框", message: "账号已注册", preferredStyle: UIAlertController.Style.alert)
                let delAction = UIAlertAction(title: "确定", style: .default, handler: {
                    (UIAlertAction)->Void in
                    self.id.text = ""
                    self.passwd.text = ""
                })
                alertControl.addAction(delAction)
                self.present(alertControl, animated:true)
                return
            }
        } catch {
            print("error in login")
        }
        //新生成用户并存储到后端中
        let passwd = passwd.text!
        let name = name.text!
        let age = age.text!
        let sex = sex.text!
        //新建一个实体
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        //将实体插入上下文
        let theUser = NSManagedObject(entity: entity, insertInto: managedContext)
        //初始化user
        theUser.setValue(name, forKey: "name")
        theUser.setValue(Int32(age)!, forKey: "age")
        theUser.setValue(sex, forKey: "sex")
        theUser.setValue("社员", forKey: "job")
        theUser.setValue("myPhoto", forKey: "photo")
        theUser.setValue(id, forKey: "id")
        theUser.setValue(passwd, forKey: "passwd")
        theUser.setValue(0, forKey: "worktime")
        do {
            try managedContext.save()
        } catch{
            let nsError = error as NSError
            print("error in register!", nsError.localizedDescription)
        }
        //希望将注册界面得到的信息打包发送给注册页面
        self.dismiss(animated: true) {
            () -> Void in
            //收集用户信息
            let userInfo = ["id": self.id.text!, "passwd":
                            self.passwd.text!]
            //调用一个事件
            NotificationCenter.default.post(name:
                Notification.Name(rawValue: "RegisterSubmitNotifaction"), object: nil, userInfo: userInfo)
        }
    }
    

    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        print("hello")
        self.sex.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        //点击取消让自己消失
        self.dismiss(animated: true, completion: nil)
    }
}
