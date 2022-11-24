import UIKit
import Charts
 
class WorkChartsViewController: UIViewController {
     
    //折线图
    var chartView: LineChartView!
    var barchartView: BarChartView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //创建折线图组件对象
        chartView = LineChartView()
        chartView.frame = CGRect(x: 20, y: 100, width: self.view.bounds.width - 40,
                                 height: 300)
        self.view.addSubview(chartView)
         
        var dataEntries = [ChartDataEntry]()
        for i in 0..<7 {
            let y = (arc4random() + 3)%12
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        
        //折线图无数据时显示的提示文字
        chartView.noDataText = "您还没有解锁个人成就，快去参与夜巡吧！"
        chartView.chartDescription.text = "本周统计"
        
        //设置交互样式
        chartView.scaleYEnabled = false //取消Y轴缩放
        chartView.doubleTapToZoomEnabled = true //双击缩放
        chartView.dragEnabled = true //启用拖动手势
        chartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
        //这20条数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "公里数(km)")
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        
        //将线条颜色设置为橙色
        chartDataSet.colors = [.orange]
        
        //修改线条大小
        chartDataSet.lineWidth = 2
        
        chartDataSet.circleColors = [.yellow]  //外圆颜色
        chartDataSet.circleRadius = 6 //外圆半径
        chartDataSet.drawCircleHoleEnabled = false  //不绘制转折点内圆
        
        chartDataSet.mode = .cubicBezier  //曲线
        
        chartDataSet.valueColors = [.blue] //拐点上的文字颜色
        chartDataSet.valueFont = .systemFont(ofSize: 9) //拐点上的文字大小
        
        //开启填充色绘制
        chartDataSet.drawFilledEnabled = true
        //渐变颜色数组
        let gradientColors = [UIColor.orange.cgColor, UIColor.white.cgColor] as CFArray
        //每组颜色所在位置（范围0~1)
        let colorLocations:[CGFloat] = [1.0, 0.0]
        //生成渐变色
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors, locations: colorLocations)
        //将渐变色作为填充对象s
        chartDataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        
        chartDataSet.highlightColor = .blue //十字线颜色
        chartDataSet.highlightLineWidth = 2 //十字线线宽
        chartDataSet.highlightLineDashLengths = [4, 2] //使用虚线样式的十字线
        
        chartView.xAxis.labelPosition = .bottom //x轴显示在下方
        //自定义刻度标签文字
        let xValues = ["周末","周一","周二","周三","周四","周五","周六"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        chartView.xAxis.labelCount = 7
        chartView.xAxis.granularity = 1 //最小间隔
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 6
        chartView.xAxis.forceLabelsEnabled = true
        chartView.xAxis.granularityEnabled = true
        
        chartView.xAxis.drawGridLinesEnabled = false //不绘制网格线
        //播放y轴方向动画，持续时间1秒，动画效果是先快后慢
        chartView.animate(xAxisDuration: 0.5)
        //设置折现图数据
        chartView.data = chartData
        
        
        //柱状图
        //创建柱状图组件对象
        barchartView = BarChartView()
        barchartView.frame = CGRect(x: 20, y: 500, width: self.view.bounds.width - 40,
                                 height: 300)
        self.view.addSubview(barchartView)
        
        //设置交互样式
        barchartView.scaleYEnabled = false //取消Y轴缩放
        barchartView.doubleTapToZoomEnabled = true //双击缩放
        barchartView.dragEnabled = true //启用拖动手势
        barchartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        barchartView.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
         
        //生成10条随机数据
        var barDataEntries = [BarChartDataEntry]()
        for i in 0..<12 {
            let y = (arc4random() + 50)%100
            let entry = BarChartDataEntry(x: Double(i), y: Double(y))
            barDataEntries.append(entry)
        }
        //这20条数据作为柱状图的所有数据
        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "公里数")
        //目前柱状图只包括1组立柱
        let barCharData = BarChartData(dataSets: [barChartDataSet])
         
        barChartDataSet.colors  = [.yellow, .orange, .red]
        
        barchartView.xAxis.labelPosition = .bottom //x轴显示在下方
        let barXValues = ["一月","二月","三月","四月","五月","六月","七月", "八月", "九月", "十月", "十一月", "十二月"]
        barchartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: barXValues)
        barchartView.xAxis.labelCount = 12
        barchartView.xAxis.granularity = 1 //最小间隔
        barchartView.xAxis.axisMinimum = 0
        barchartView.xAxis.axisMaximum = 11
        barchartView.xAxis.forceLabelsEnabled = true
        barchartView.xAxis.granularityEnabled = true
        
        //设置柱状图数据
        barchartView.animate(xAxisDuration: 0.5)
        barchartView.data = barCharData
    }
}
