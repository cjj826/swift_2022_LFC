import UIKit
import CoreData

class UserTableController: UITableViewController, UISearchBarDelegate {
    
    var userInfo1 : UserInfo! =  UserInfo()//要展示的数据
    
    var collection1 :[NSManagedObject] = []
    
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
                if name.lowercased().hasPrefix(searchText.lowercased()) {
                    self.collection1.append(user)
                }
            }
        }
        print("is going to reload")
        print(collection1)
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection1.count //表格一共多少行
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    required init?(coder aDeconder: NSCoder) {
        super.init(coder: aDeconder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
}
