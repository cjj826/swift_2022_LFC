import UIKit
import CoreData

class GroupMemberViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var userInfo1 : UserInfo! //从后端获取的数据
    var curUser: NSManagedObject? = nil
    
    var collection1 :[NSManagedObject] = [] //要展示的数据
    @IBOutlet var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //没有内容是显示全部
        if searchText == "" {
            self.collection1 = userInfo1.usersCollection
        } else {
            //匹配输入内容的前缀
            self.collection1 = []
            for user in userInfo1.usersCollection {
                let name : String = (user.value(forKey: "name") as? String)!
                if name.lowercased().contains(searchText.lowercased()) {
                    self.collection1.append(user)
                }
            }
        }
        print("is going to reload")
        print(collection1)
        self.tableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection1.count //表格一共多少行
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //返回每一个cell的内容
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = collection1[indexPath.row]
        cell.photo.image = UIImage(named: (user.value(forKey: "photo") as? String ?? "myPhoto"))
        cell.name.text = user.value(forKey: "name") as? String
        cell.sex.text = user.value(forKey: "sex") as? String
        cell.job.text = user.value(forKey: "job") as? String
        cell.age.text = "\(user.value(forKey: "age") as! Int32)"
        return cell
    }
    
    //增加按钮
    @IBAction func switchmode(_ sender: Any) {
        //注意这里要改为self.tableview
        if (!isBoss()) {
            return;
        }
        if self.tableview.isEditing {
            self.tableview.setEditing(false, animated: true)
        } else {
            self.tableview.setEditing(true, animated: true)
        }
    }
    
    func isBoss() -> Bool {
        if self.curUser?.value(forKey: "job") as! String != "社长" {
            let alert = UIAlertController(title: "警告", message: "只有社长才能编辑社团成员列表", preferredStyle: .alert)
            let Action = UIAlertAction(title: "确认", style: .default)
            alert.addAction(Action)
            present(alert, animated: true)
            return false
        }
        return true
    }
    
    //增加 表单输入
    @IBAction func add_student(_ sender: Any) {
       collection1 = userInfo1.usersCollection //
        if (!isBoss()) {
            return;
        }
        let alert = UIAlertController(title: "添加一条社员信息", message: "请依次输入姓名/年龄", preferredStyle: .alert)
        
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="姓名"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="年龄"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="性别"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="账号"}

        let saveAction = UIAlertAction(title: "Save", style: .default) {[unowned self] action in
            let theName = alert.textFields?[0].text
            let theAge = alert.textFields?[1].text
            let theSex = alert.textFields?[2].text
            let theID = alert.textFields?[3].text
            
            let theUser = self.userInfo1.addUser(name: theName!, age:  Int32(theAge!)!, sex: theSex!, job: "社员", photo: "myPhoto", id: theID!, passwd: "123456", worktime: Int32(0))
            
            if let index = self.userInfo1.usersCollection.firstIndex(of: theUser) {
                let theIndexPath = IndexPath(row: index, section: 0)
                collection1.append(theUser)
                self.tableview.insertRows(at: [theIndexPath], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        collection1 = userInfo1.usersCollection
        if editingStyle == .delete {
            let user = userInfo1.usersCollection[indexPath.row]
            //三个容器需要保持同步
            if let index = collection1.firstIndex(of: user) {
                collection1.remove(at: index)
            }
            userInfo1.delUser(theuser: user as! User)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    //移动
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        userInfo1.trans(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        userInfo1.saveUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("切换至社团成员界面，重新加载数据库中内容至前端")
        let parentController = self.tabBarController as! TabBarViewController
        self.curUser = parentController.user
        self.userInfo1 = UserInfo()
        self.collection1 = userInfo1.usersCollection
        self.tableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let theMFView = segue.destination as! MFViewController
        
        let sum = userInfo1.usersCollection.count
        var male: Int = 0
        var fmale: Int = 0
        var maxAge: Int32 = Int32.min
        var minAge: Int32 = Int32.max
        var sumAge: Int32 = 0
        
        for user in userInfo1.usersCollection {
            let sex : String = (user.value(forKey: "sex") as? String)!
            if sex == "男" {
                male += 1
            } else if sex == "女" {
                fmale += 1
            }
            let age : Int32 = user.value(forKey: "age") as! Int32
            if (age > maxAge) {
                maxAge = age
            }
            if (age < minAge) {
                minAge = age
            }
            sumAge += age
        }
        print(male, fmale, sum, maxAge, minAge)
        theMFView.maleCount = String(format: "%.1f", Double(male)/Double(sum)*100)
        theMFView.femaleCount = String(format: "%.1f", Double(fmale)/Double(sum)*100)
        theMFView.maxAge = "\(maxAge)岁"
        theMFView.minAge = "\(minAge)岁"
        theMFView.aAge = "\(sumAge / Int32(sum))岁"
    }

}
