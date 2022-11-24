import UIKit
import AVKit
import AVFoundation
 
class VideoPlayViewController: UIViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playVideo(_ sender: Any) {
        print("going to show!!!")
        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "video", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: filePath!)
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
