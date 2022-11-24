import UIKit
import CoreData

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //添加一个观察者，接受事件
        NotificationCenter.default.addObserver(self, selector: #selector(autoFill), name: Notification.Name(rawValue: "RegisterSubmitNotifaction"), object: nil)
    }
    
    @IBOutlet var id: UITextField!
    @IBOutlet var passwd: UITextField!
    var flag: Bool = true //是否初次启动，若为初次启动需要加载用户信息到空coredata中
    
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
    
    //将用户id传输到之后的页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("the destination is ",type(of: segue.destination))
        
        if segue.identifier == "login" {
            let theBarController = segue.destination as! TabBarViewController
            theBarController.id = self.id.text!
        }
    }
    
    
    
    //验证登陆是否正确 用户名不存在 密码不正确
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "login" {
            return true
        }
        let id = self.id.text
        let passwd = self.passwd.text
        
        //拿出数据库上下文
        let managedContext = persitentContainer.viewContext
        
        //条件抓取实体
        let fetchUser = NSFetchRequest<User>(entityName: "User")
        fetchUser.predicate = NSPredicate(format: "id = \"\(id!)\"")
        do {
            let users = try managedContext.fetch(fetchUser)
            if (users.isEmpty) {
                print("用户名不存在")
            } else if (users.count == 1){
                let realpd = users[0].passwd
                if (passwd != realpd) {
                    print("密码错误")
                } else {
                    print("登录成功")
                    return true
                }
            } else {
                print("用户名重复！！！")
            }
        } catch {
            print("error in login")
            return false
        }
        let alertControl : UIAlertController = UIAlertController(title: "警告框", message: "账号不存在或者密码错误", preferredStyle: UIAlertController.Style.alert)
        let delAction = UIAlertAction(title: "确定", style: .default, handler: {
            (UIAlertAction)->Void in
            self.id.text = ""
            self.passwd.text = ""
        })
        alertControl.addAction(delAction)
        self.present(alertControl, animated:true)
        return false
    }
    
    
    @objc func autoFill(_ notification:Notification) {
        let userInfo = notification.userInfo!
        let id = userInfo["id"] as! String
        let passwd = userInfo["passwd"] as! String
        self.id.text = id
        self.passwd.text = passwd
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.id.text = ""
        self.passwd.text = ""
        if flag {
            //初次启动
            flag = false
            print("初次启动，加载基础用户数据至本地coredata中")
            print(UserInfo())//要展示的数据
        }
    }
}

