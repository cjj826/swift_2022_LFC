import UIKit
import CoreData
import Photos

class PersonViewController:UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var job: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var age: UILabel!
    
    @IBOutlet var sex: UILabel!
    
    
    var user: NSManagedObject? = nil
//    self.tabBarController.id
    override func viewWillAppear(_ animated: Bool) {
        print("加载个人中心界面")
        let parentController = self.tabBarController as! TabBarViewController
        self.user = parentController.user
        getUser()
    }
    
    func getUser() {
//        self.user = parentController.user
        self.photo.image = UIImage(named: (self.user?.value(forKey: "photo") as? String ?? "myPhoto"))
        self.name.text = self.user?.value(forKey: "name") as? String
        self.sex.text = self.user?.value(forKey: "sex") as? String
        self.job.text = self.user?.value(forKey: "job") as? String
        self.age.text = "\(self.user?.value(forKey: "age") as! Int32)"
        
    }
    

    @IBAction func changeInfo(_ sender: Any) {
        let alert = UIAlertController(title: "修改个人信息", message: "请依次输入姓名/年龄/性别", preferredStyle: .alert)
        
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="姓名"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="年龄"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="性别"}

        let saveAction = UIAlertAction(title: "Save", style: .default) {[unowned self] action in
            let theName = alert.textFields?[0].text
            let theAge = alert.textFields?[1].text
            let theSex = alert.textFields?[2].text
            self.user?.setValue(theName, forKey: "name")
            self.user?.setValue(Int32(theAge!), forKey: "age") //缺省为18？
            self.user?.setValue(theSex, forKey: "sex")
            let parentController = self.tabBarController as! TabBarViewController
            print(parentController.user)
            print(parentController.user?.value(forKey: "name"))
            self.save()
            self.getUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    func save() {
        let parentController = self.tabBarController as! TabBarViewController
        
        let managedContext = parentController.persitentContainer.viewContext //拿出文本 11.15必须和viewController保持一致
        
        //如果文本有变化再保存
        if managedContext.hasChanges {
            print("save!!!")
            do {
                try managedContext.save()
            } catch{
                let nsError = error as NSError
                print("error in saving data!", nsError.localizedDescription)
            }
        }
    }
    
    
    @IBAction func changePasswd(_ sender: Any) {
        let alert = UIAlertController(title: "修改密码", message: "请输入新密码", preferredStyle: .alert)
        
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="新密码"}
//        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder="再次输入密码"}

        let saveAction = UIAlertAction(title: "Save", style: .default) {[unowned self] action in
            let thePasswd = alert.textFields?[0].text
            self.user?.setValue(thePasswd, forKey: "passwd")
            self.save()
            self.getUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //上传图片并修改头像
    @IBAction func changePhoto(_ sender: Any) {
        // 选择上传照片方式的弹窗设置
        let addImageAlertViewController = UIAlertController(title: "请选择上传方式", message: "相册或者相机", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction) in self.cameraAction()
        })
        let albumAction = UIAlertAction(title: "从相册选择", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction) in self.albumAction()
        })
        addImageAlertViewController.addAction(cancelAction)
        addImageAlertViewController.addAction(cameraAction)
        addImageAlertViewController.addAction(albumAction)
        present(addImageAlertViewController, animated: true)
    }
    
    // MARK: - 拍照监听方法
    func cameraAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            // 创建图片控制器
            let picker = UIImagePickerController()
            
            // 设置代理
            picker.delegate = self
            
            // 设置来源
            picker.sourceType = UIImagePickerController.SourceType.camera
            
            // 允许编辑
            picker.allowsEditing = true
            
            // 打开相机
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else {
            // 弹出提示
            let title = "找不到相机"
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:"我知道了", style: .cancel, handler:nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - 相册监听方法
    func albumAction() {
        // 可选照片数量
        let count = 1

        // 开始选择照片，最多允许选择count张
        _ = self.presentAlbumImagePicker(maxSelected: count) { (assets) in
            
            // 结果处理
            for asset in assets {
                // 从asset获取image
                let image = self.PHAssetToUIImage(asset: asset)
                
                self.photo.image = image
            }
        }
    }
    
    // MARK: - 将PHAsset对象转为UIImage对象
    func PHAssetToUIImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        // 可能有bug!!! photo.bounds.size
        imageManager.requestImage(for: asset, targetSize: self.photo.bounds.size, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }
    
}

