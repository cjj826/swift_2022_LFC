import UIKit
import CoreData

class DetailStyleController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var info: UILabel!
    
    @IBOutlet var like: UILabel!
    
    var comments : NSOrderedSet = []
    
    @IBAction func add_like(_ sender: Any) {
        var s = theStyle.like!
        //查看用户是否已经赞过
        let set = s.components(separatedBy: ",")
        let id = theUSer.id!
        if (set.contains(id)) {
            let alert = UIAlertController(title: "提示", message: "您已经赞过了", preferredStyle: .alert)
            let Action = UIAlertAction(title: "确认", style: .default)
            alert.addAction(Action)
            present(alert, animated: true)
        } else {
            s += id
            s += ","
            print("somenoe like",theUSer.id ?? "-1")
            theStyle.setValue(s, forKey: "like")
            self.like.text = "\(s.components(separatedBy: ",").count - 1)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row] as! Comment
        cell.photo.image = UIImage(named: (comment.value(forKey: "photo") as? String ?? "myPhoto"))
        cell.name.text = comment.value(forKey: "name") as? String
        cell.describe.text = comment.value(forKey: "describe") as? String
        cell.time.text = comment.value(forKey: "time") as? String
        return cell
    }
    
    @IBAction func addComment(_ sender: Any) {
        let alert = UIAlertController(title: "发布新评论", message: "请输入您的评论", preferredStyle: .alert)
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="评论"}
        let saveAction = UIAlertAction(title: "保存", style: .default) {[unowned self] action in
            let theDes = alert.textFields?[0].text
            let managedContext: NSManagedObjectContext = theStyle.managedObjectContext!
            let entity = NSEntityDescription.entity(forEntityName: "Comment", in: managedContext)!
            let theComment = NSManagedObject(entity: entity, insertInto: managedContext)
            theComment.setValue(theUSer.name, forKey: "name")
            theComment.setValue(theUSer.photo, forKey: "photo")
            theComment.setValue(currentTime(), forKey: "time")
            theComment.setValue(theDes, forKey: "describe")
            theStyle.mutableOrderedSetValue(forKey: "contactsComment").add(theComment)
            do {
                try managedContext.save()
            } catch{
                let nsError = error as NSError
                print("error in saving data!", nsError.localizedDescription)
            }
            comments = theStyle.contactsComment!
            print("after add, the count is \(comments.count)")
            tableview.reloadData()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    func currentTime() -> String {
        let date = DateFormatter()
        date.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return date.string(from: Date())
    }
    
    @IBOutlet var tableview: UITableView!
    
    var theStyle:  Style!
    var theUSer: User!
    var fatherView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        name.text = theStyle.title
        info.text = theStyle.describe
        let s = theStyle.like!
        like.text = "\(s.components(separatedBy: ",").count - 1)"
        comments = theStyle.contactsComment! //获取评论列表
        photo.image = UIImage(named: theStyle.photo ??  "mountain")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fatherView.reloadData()
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
}
