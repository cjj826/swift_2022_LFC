import UIKit
import Charts

class MFViewController : UIViewController {
    
    var femaleCount :String = ""
    var maleCount :String = ""
    var maxAge :String = ""
    var minAge :String = ""
    var aAge :String = ""
    
    @IBOutlet var fmale: UILabel!
    
    @IBOutlet var male: UILabel!
    
    @IBOutlet var MaxAge: UILabel!
    
    @IBOutlet var MinAge: UILabel!
    
    @IBOutlet var Avgage: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fmale.text = femaleCount + "%"
        self.male.text = maleCount + "%"
        self.MaxAge.text = maxAge
        self.MinAge.text = minAge
        self.Avgage.text = aAge
    }
    
    //饼状图
    var chartView: PieChartView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //创建饼图组件对象
        chartView = PieChartView()
        chartView.frame = CGRect(x: 20, y: 300, width: self.view.bounds.width - 40,
                                 height: 260)
        self.view.addSubview(chartView)
        
        var dataEntries = [PieChartDataEntry]()

        var data: Double = Double(self.maleCount) ?? 0.5
        var entry = PieChartDataEntry(value: data, label:"男生")
        dataEntries.append(entry)
        data = Double(self.femaleCount) ?? 0.5
        entry = PieChartDataEntry(value: data, label:"女生")
        dataEntries.append(entry)
        
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "男女比例")
        //设置颜色
        chartView.centerText = "成员男女比"
        chartDataSet.colors = [.blue, .red]
        let chartData = PieChartData(dataSet: chartDataSet)
         
        //设置饼状图数据
        chartView.data = chartData
        chartView.animate(xAxisDuration: 0.5)
    }

    
}
