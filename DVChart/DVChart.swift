//
//  DVChart.swift
//  DVChart
//
//  Created by Vinh Dang Duc on 7/2/15.
//  Copyright © 2015 Vinh Dang Duc. All rights reserved.
//

import UIKit

class DVChart: UIViewController {
    
    // Properties
    
    enum ChartType {
        case PieChart
        case BarChart
        case LineChart
    }
    
    var pieChart: PieChart?
    var barChart: BarChart?
    var lineChart: LineChart?
    var chartType: ChartType = ChartType.PieChart
    weak var currentChart: UIView!
    
    var chartFrame: CGRect!
    weak var target: UIViewController!
    
    var data: [String: Int]? {
        didSet {
            switch self.chartType {
            case .PieChart:
                if self.pieChart != nil { self.pieChart!.data = self.data }
                break
            case .BarChart:
                if self.barChart != nil { self.barChart!.data = self.data }
                break
            case .LineChart:
                if self.lineChart != nil { self.lineChart!.data = self.data }
                break
            }
        }
    }
    
    var colorTable: [UIColor]?
    
    // MARK: - Init Methods
    
    init(target: UIViewController,frame: CGRect, data: [String: Int]) {
        super.init(nibName: nil, bundle: nil)
        self.target = target
        self.chartFrame = frame
        self.data = data
        
        setupMainView()
        setupChart()
    }
    
    init(target: UIViewController, frame: CGRect, type: ChartType, data: [String: Int]) {
        super.init(nibName: nil, bundle: nil)
        self.target = target
        self.chartFrame = frame
        self.chartType = type
        self.data = data
        
        setupMainView()
        setupChart()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View States Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Set Up Chart
    
    private func setupMainView() {
        self.view.frame = chartFrame
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    private func setupChart() {
        let chartSize = min(chartFrame.width, chartFrame.height)
        switch chartType {
        case .PieChart:
            pieChart = PieChart(frame: CGRect(x: 0, y: 0, width: chartSize, height: chartSize), data: data!)
            pieChart?.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
            view.addSubview(pieChart!)
            target.addChildViewController(self)
            target.view.addSubview(self.view)
            self.didMoveToParentViewController(target)
            currentChart = pieChart
            break
        case .BarChart:
            barChart = BarChart(frame: CGRect(x: 0, y: 0, width: chartSize, height: chartSize), data: data!)
            barChart?.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
            view.addSubview(barChart!)
            target.addChildViewController(self)
            target.view.addSubview(self.view)
            self.didMoveToParentViewController(target)
            currentChart = barChart

            currentChart = barChart
            break
        case.LineChart:
            lineChart = LineChart(frame: chartFrame)
            currentChart = lineChart
            break
        }
    }
    
    // MARK: - Chart Animations
    
    func show() {
        if currentChart == nil { return }
        showChart(currentChart)
        currentChart.setNeedsDisplay()
    }
    
    private func showChart(chart: UIView) {
        if chart.hidden { chart.hidden = false }
    }
    
    func hide() {
        if currentChart == nil { return }
        currentChart.hidden = true
    }
}

class PieChart: UIView {
    
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }
    
    var labelArray = [UILabel]()
    var arcWidth: CGFloat = 130
    let pi: CGFloat = CGFloat(M_PI)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        setupArcWidth()
    }
    
    init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame)
        setupArcWidth()
        self.data = data
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupArcWidth() {
//        arcWidth = min(bounds.width, bounds.height)/2 - min(bounds.width, bounds.height)/11
        arcWidth = min(bounds.width, bounds.height)/2
    }
    
    override func drawRect(rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetFillColorWithColor(context, UIColor.randomColor().CGColor)
//        CGContextFillRect(context, rect);
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [UIColor.randomColor().CGColor, UIColor.randomColor().CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
//        CGContextFillRect(context, rect)
        
        let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        let radius = min(self.bounds.width, self.bounds.height)/2 - arcWidth/2
        
        let startAngle = 3 * pi / 2
//        let endAngle = 7 * pi / 2
        
        var amount = 0
        for object in data!.values { amount += object }
 
        let bigAngle = 2 * pi
        let subAngle = bigAngle / CGFloat(amount)
        
        var startSubAngle = startAngle
        var endSubAngle = startAngle
        
        if labelArray.count != 0 {
            for label in labelArray {
                label.removeFromSuperview()
            }
            labelArray.removeAll()
        }
        
        for (key,value) in data! {
            startSubAngle = endSubAngle
            endSubAngle = startSubAngle + subAngle * CGFloat(value)
            
            let subPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startSubAngle, endAngle: endSubAngle, clockwise: true)
            subPath.lineWidth = arcWidth
            UIColor.randomColor().setStroke()
            subPath.stroke()

            addLabelToChartPiece("\(key): \(String(value))%", startAngle: startSubAngle, endAngle: endSubAngle)
        }
    }
    
    func addLabelToChartPiece(text: String, startAngle: CGFloat, endAngle: CGFloat) {
        let firstPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        let firstLabelAngle = startAngle - (2 * pi)
        let secondLabelAngle = endAngle - (2 * pi)
        
        let chartCircleRad: CGFloat = self.frame.width/2
        
        let secondX = (cos(firstLabelAngle) * chartCircleRad) + chartCircleRad
        let secondY = chartCircleRad + (sin(firstLabelAngle) * chartCircleRad)
        let secondPoint = CGPoint(x: secondX, y: secondY)
        
        let thirdX = (cos(secondLabelAngle) * chartCircleRad) + chartCircleRad
        let thirdY = chartCircleRad + (sin(secondLabelAngle) * chartCircleRad)
        let thirdPoint = CGPoint(x: thirdX, y: thirdY)
        
        let labelCenterX = (firstPoint.x + secondPoint.x + thirdPoint.x) / 3
        let labelCenterY = (firstPoint.y + secondPoint.y + thirdPoint.y) / 3
        
        let labelCenter = CGPoint(x: labelCenterX, y: labelCenterY)
        
        let myText: NSString = text as NSString
        let textSize: CGSize = myText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)])
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height))
        label.center = labelCenter
        label.backgroundColor = UIColor.randomColor()
        label.layer.borderWidth = 0
        label.layer.borderColor = UIColor.blackColor().CGColor
        label.layer.shadowOpacity = 0.2
        label.text = text
        label.font = UIFont(name: "Helvetica", size: 11)
        label.textAlignment = NSTextAlignment.Center
        
        labelArray.append(label)
        
        self.addSubview(label)
    }
}

class BarChart: UIView {
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }
    
    var verticalAxisLabels: [UILabel]?
    var horizontalAxisLabels: [UILabel]?
    var margin: CGFloat = 10
    let distanceBetweenColumns = 10
    let axesLineWidth: CGFloat = 2
    let arrowAxesSizeX: CGFloat = 3
    let arrowAxesSizeY: CGFloat = 3
    
    let axesColor = UIColor.blackColor()
    let columnColor = UIColor.randomColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMarginForChart()
        self.backgroundColor = UIColor.clearColor()
    }
    
    init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame)
        setMarginForChart()
        self.backgroundColor = UIColor.clearColor()
        self.data = data
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMarginForChart() {
        margin = self.bounds.width/12
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let colors = [UIColor.randomColor().CGColor, UIColor.randomColor().CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        // Let's begin !!!
        
        // Step 1: Drawing columns of chart
        
        for i in 0..<data!.count {
            let originPosition = getOriginPositionOfColumn(i)
            let horizontalY = self.bounds.height - margin
            let columnWidth = getColumnWidth()
            
            let columnPath = UIBezierPath()
            columnPath.moveToPoint(CGPoint(x: originPosition.x, y: horizontalY))
            columnPath.addLineToPoint(CGPoint(x: originPosition.x, y: originPosition.y))
            columnPath.addLineToPoint(CGPoint(x: originPosition.x + columnWidth, y: originPosition.y))
            columnPath.addLineToPoint(CGPoint(x: originPosition.x + columnWidth, y: horizontalY))
            columnPath.closePath()
            
            UIColor.randomColor().setFill()
            columnPath.fill()
        }
        
        // Step 2: Drawing axes of chart
        
        let axesPath = UIBezierPath()
        axesPath.moveToPoint(CGPoint(x: margin, y: margin))
        axesPath.addLineToPoint(CGPoint(x: margin-arrowAxesSizeX, y: margin+arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: margin, y: margin))
        axesPath.addLineToPoint(CGPoint(x: margin+arrowAxesSizeX, y: margin+arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: margin, y: margin))
        
        axesPath.addLineToPoint(CGPoint(x: margin, y: self.bounds.height-margin))
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin, y: self.bounds.height-margin))
        
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin-arrowAxesSizeX, y: self.bounds.height-margin-arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: self.bounds.width-margin, y: self.bounds.height-margin))
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin-arrowAxesSizeX, y: self.bounds.height-margin+arrowAxesSizeY))
        
        
        axesPath.lineWidth = axesLineWidth
        axesColor.setStroke()
        axesPath.stroke()
        axesPath.closePath()
    }
    
    func getOriginPositionOfColumn(index: Int) -> CGPoint {
        let maxValue = data!.values.array.reduce(Int.min, combine: { max($0, $1) })
        let columnValue = getTheColumnValue(column: index)
        let columnWidth = getColumnWidth()
        let chartHeight = self.bounds.height - (2 * margin)
        
        let posX = margin + CGFloat((distanceBetweenColumns * (index + 1))) + (columnWidth * CGFloat(index))
        let posY = margin + (chartHeight - (CGFloat(columnValue)/CGFloat(maxValue)) * chartHeight)
        return CGPoint(x: posX, y: posY)
    }
    
    func getColumnWidth() -> CGFloat {
        let dataCount = data!.count
        let chartWidth = self.bounds.width - (2 * margin)
        return (chartWidth - CGFloat((distanceBetweenColumns * (dataCount+1)))) / CGFloat(dataCount)
    }
    
    func getTheColumnValue(column column: Int) -> Int {
        return data!.values.array[column]
    }
    
    func getTheTotalAmountOfData() -> Int {
        var amount = 0
        for object in data!.values { amount += object }
        return amount
    }
}

class LineChart: UIView {
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }

    override func drawRect(rect: CGRect) {
        
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
