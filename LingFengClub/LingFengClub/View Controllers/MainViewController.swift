import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var page: UIPageControl!
    var imageName: [String] = ["loop-1", "loop-2", "loop-3"]
    var index = 0
    var timer: Timer!
    
    @IBOutlet var commityStyle: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(going), userInfo: nil, repeats: true)
        print("主界面出现")
    }
    
    @objc func going() {
        index = (index + 1) % 3
        page.currentPage = index
        commityStyle.image = UIImage(named: imageName[index])
    }
    
    @IBAction func forward(_ sender: Any) {
        going()
    }
    
    @IBAction func back(_ sender: Any) {
        if index <= 0 {
            index = 2
        } else {
            index = index - 1
        }
        page.currentPage = index
        commityStyle.image = UIImage(named: imageName[index])
    }
    
    
    required init?(coder aDeconder: NSCoder) {
        //开机即执行一次，树状导航执行一次，但是tab导航不执行
        super.init(coder: aDeconder)
        print("init for 主页面 here!")
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

}

