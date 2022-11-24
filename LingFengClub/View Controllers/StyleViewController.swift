import UIKit

import CoreData
import Photos

class StyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var styleInfo1: StyleInfo!
    var user: User!

    @IBOutlet var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styleInfo1.styleCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath) as! StyleCell
        let style = styleInfo1.styleCollection[indexPath.row]
        
        cell.photo.image = UIImage(named: (style.value(forKey: "photo") as? String ?? "mountain"))
        cell.describe.text = style.value(forKey: "describe") as? String
        cell.title.text = style.value(forKey: "title") as? String
        let s = style.value(forKey: "like") as! String
        let count: Int = s.components(separatedBy: ",").count - 1
        cell.like.text = "\(count)" //以逗号分隔，分组数-1
        return cell
    }
    
    @IBAction func add_like(_ sender: Any) {
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)!
        let indexPath = self.tableview.indexPath(for: cell)
        if let row = indexPath?.row {
            let thestyle = styleInfo1.styleCollection[row] as! Style
            var s = thestyle.like!
            //查看用户是否已经赞过
            let id = user.id!
            let set = s.components(separatedBy: ",")
            if (set.contains(id)) {
                let alert = UIAlertController(title: "提示", message: "您已经赞过了", preferredStyle: .alert)
                let Action = UIAlertAction(title: "确认", style: .default)
                alert.addAction(Action)
                present(alert, animated: true)
            } else {
                s += id
                s += ","
                print("somenoe like",user.id ?? "-1")
                thestyle.setValue(s, forKey: "like")
                print(s)
                self.styleInfo1.saveStyle()
                self.tableview.reloadData()
            }
        }
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? StyleCell {
                return cell
            }
        }
        return nil
    }

    
    @IBAction func swiftchMode(_ sender: Any) {
        print("尝试触发")
        if (!isBoss()) {
            return;
        }
        if self.tableview.isEditing {
            (sender as! UIButton).setTitle("编辑", for: .normal)
            self.tableview.setEditing(false, animated: true)
        } else {
            (sender as! UIButton).setTitle("确认", for: .normal)
            self.tableview.setEditing(true, animated: true)
        }
    }
    
    func isBoss() -> Bool {
        if self.user?.value(forKey: "job") as! String != "社长" {
            let alert = UIAlertController(title: "警告", message: "只有社长才能编辑活动列表", preferredStyle: .alert)
            let Action = UIAlertAction(title: "确认", style: .default)
            alert.addAction(Action)
            present(alert, animated: true)
            return false
        }
        return true
    }

    
    
    @IBAction func add_activity(_ sender: Any) {
        //输入活动标题/内容/照片名
        let alert = UIAlertController(title: "发布新活动", message: "请依次输入标题/描述/照片名", preferredStyle: .alert)
        
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="标题"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="描述"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="照片名"}
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {[unowned self] action in
            let theName = alert.textFields?[0].text
            let theDes = alert.textFields?[1].text
            let thePhoto = alert.textFields?[2].text
            
            let theStyle = self.styleInfo1.addStyle(title: theName!, describe:theDes!, photo: thePhoto!)
            if let index = self.styleInfo1.styleCollection.firstIndex(of: theStyle) {
                let theIndexPath = IndexPath(row: index, section: 0)
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
        if editingStyle == .delete {
            let style = styleInfo1.styleCollection[indexPath.row]
            styleInfo1.delStyle(thestyle: style as! Style)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    required init?(coder aDeconder: NSCoder) {
        super.init(coder: aDeconder)
//        viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("社团风采界面出现")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("切换至社团风采界面，重新加载数据库中内容至前端")
        let parentController = self.tabBarController as! TabBarViewController
        self.user = parentController.user as? User
        self.styleInfo1 = StyleInfo()
        self.tableview.reloadData()
    }
    
    //跳转到新页面之前
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Row = self.tableview.indexPathForSelectedRow
        if let row = Row?.row {
            let thestyle = styleInfo1.styleCollection[row]
            //获取目标页面的ViewControl
            let thedetailViewController = segue.destination as! DetailStyleController    
            thedetailViewController.theStyle = thestyle as! Style
            thedetailViewController.theUSer = user!
            thedetailViewController.fatherView = tableview!
        }
    }
}
