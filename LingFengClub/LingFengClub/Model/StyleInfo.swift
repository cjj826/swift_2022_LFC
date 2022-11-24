import UIKit
import CoreData

class StyleInfo {
    var styleCollection = [NSManagedObject]()
    
    
    
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Style")
        
        do {
            //结果赋给前端容器
            styleCollection = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("can not catch.\(error), \(error.userInfo)")
        }
        if (styleCollection.isEmpty) {
            initStyle()
        }
    }
    
    func saveStyle() {
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
    
    func addStyle(title: String, describe: String, photo: String) -> Style{
        let managedContext = persitentContainer.viewContext
        //新建一个实体
        let entity = NSEntityDescription.entity(forEntityName: "Style", in: managedContext)!
        //将实体插入上下文
        let theStyle = NSManagedObject(entity: entity, insertInto: managedContext)
        theStyle.setValue(title, forKey: "title")
        theStyle.setValue(describe, forKey: "describe")
        theStyle.setValue(photo, forKey: "photo")
        theStyle.setValue(title + describe, forKey: "id")
        theStyle.setValue("", forKey: "like")
        styleCollection.append(theStyle)
        saveStyle()
        return theStyle as! Style
    }
    
    func delStyle(thestyle: Style) {
        if let index = styleCollection.firstIndex(of: thestyle) {
            //从前端中删除
            styleCollection.remove(at: index)
            //从后端中删除
            let managedContext = persitentContainer.viewContext
            managedContext.delete(thestyle)
            saveStyle()
        }
    }
    
    func initStyle() {
        //初次登陆coredata为空，因此在这里为用户提供展示数据
        print("this is the first time for start!!!")
        var photo1 = addStyle(title: "雪山上的温暖", describe: "大家在高山上相互拥抱取暖", photo: "huodong-1")
        photo1 = addStyle(title: "可爱的雪人", describe: "休息时间堆个可爱的雪人", photo: "huodong-2")
        photo1 = addStyle(title: "山脚的寺庙", describe: "西藏科考路上拍下的庄严的寺庙", photo: "huodong-3")
        var s: String = """
        一、出队地点简介

        坡峰岭，距离北京市区52km，位于北京市西南房山区。纵览景区，是春季踏青观花、夏季避暑乘凉、秋季赏漫山红叶、冬季观瑞雪奇景的佳选。如果深秋的香山是“万山红遍，层林浸染”，那么坡峰岭是“红叶绿中游，彩练当空舞”，颜色相互补充，从远处看，就像一条条彩练在空中翩翩起舞，变成了五彩的流动海洋。每年的10月至11月，每年的红叶节都在坡峰岭风景区举行。

        二、线路基本信息

        交通：1.5h+（堵车2.5h+）
        路线长度：8km爬山+2km公路 爬升：850m
        总用时：7h 运动用时：5.5h
        地点：北京市房山区涞沥水村、黄元寺村附近，坡峰岭景区（但是没走景区）

        四、总结

        风景：★★★★☆ 漫山红叶，太行余脉的山势，是这条线的两大看点
        强度：★★☆☆☆ 有一点强度
        难度：★★☆☆☆ 几个小部分容易迷路导致强穿
        风险：★☆☆☆☆ 这次其实想给一星半；假如走对路就没啥风险
        体验：★★★★☆ 风景好看，线路不难，路段多样

        这条线适合红叶季不想买门票的人走，每年的部门破冰可以考虑考虑（可是红叶季的周末又会堵车，有点别扭）。如果是完全奔着想要看特别漂亮的红叶景色来的，建议还是中途穿进景区，野路肯定没有景区观景台的景色好。除了红叶，想来看看房山的特殊山体形势，又不想走特别难的线，可以选这个。
        """
        photo1 = addStyle(title: "坡峰岭", describe: s, photo:"pfl")
        s = """
        滴！阿尼玛卿卡！
        拿到登顶证时，才发觉距离告别阿尼玛卿已经过去了正好两月。开学忙忙碌碌，时间淡去记忆，玛卿的碎石风雪也逐渐从梦中离去，快要淹没在琐事中了。
        即使是饭桌上发登顶证，也要讲求个仪式感，于是配了运动员进行曲，热热闹闹，一个一个发到手中。登顶证价格高昂，质量却极简，轻飘飘的一张，好像即将落幕的梦。
        然而当我抬起眼，你们还都在触手可及之处，在嬉笑打闹，和从前在西宁，在大武，在阿尼玛卿，甚至于再往前一点，在装备室，操场，三南的每一个日夜一样。
        从沙河出发，我们一起走过红螺三峰五台清水涧，走过万水千山，走向玛卿，走向自己，也走向你。
        为什么要登山？亲朋问我，我也常扪心自问。的确冷，也的确累，高反头痛欲绝，雪壁爬到崩溃，冲顶时血液都像掺着冰碴，下撤时脚趾甲活生生扭掉。但人总是记吃不记打，疼痛很快消褪，伤口总会愈合，但那冲顶路上那沿着陡峭山尖流下的淡金曙光，是不会忘却的。
        不是为了刺激，也不是要证明什么，我只是单纯的被吸引着，向往着山。
        因此这段记忆其实是无法被时间湮灭的，就像灰尘无法掩埋星河，它静默在脑海深处，如同玛卿峰顶亘古的雪。
        到如今只有一个遗憾了，但愿有一天，未命名登山队可以找回该有的名字，坦荡荡的告诉全世界，我们成功了。
        阿尼玛卿封山了，不知何时能再见，那就让它永恒在记忆里吧。
        """
        photo1 = addStyle(title: "阿尼玛卿雪山", describe: s, photo: "abxs")
        print("the count is ", styleCollection.count)
        print(photo1)
    }
    
}
