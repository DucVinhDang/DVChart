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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(target: UIViewController,frame: CGRect, data: [String: Int]) {
        super.init(nibName: nil, bundle: nil)
        self.target = target
        self.chartFrame = frame
        self.data = data
        setupChart()
    }
    
    init(target: UIViewController, frame: CGRect, type: ChartType, data: [String: Int]) {
        super.init(nibName: nil, bundle: nil)
        self.target = target
        self.chartFrame = frame
        self.chartType = type
        self.data = data
        setupChart()
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
    
    func setupChart() {
        switch chartType {
        case .PieChart:
            pieChart = PieChart(frame: chartFrame, data: data!)
            break
        case .BarChart:
            barChart = BarChart(frame: chartFrame)
            break
        case.LineChart:
            lineChart = LineChart(frame: chartFrame)
            break
        }
    }
    
    // MARK: - Chart Animations
    
    func show() {
        switch chartType {
        case .PieChart:
            if pieChart == nil { return }
            target.view.addSubview(pieChart!)
            break
        case .BarChart:
            if barChart == nil { return }
            target.view.addSubview(barChart!)
            break
        case.LineChart:
            if lineChart == nil { return }
            target.view.addSubview(lineChart!)
            break
        }
    }
}

class PieChart: UIView {
    
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }
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
        arcWidth = min(bounds.width, bounds.height)/2 - min(bounds.width, bounds.height)/12
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
        
        let center = self.center
        let radius = max(self.bounds.width, self.bounds.height)/2 - arcWidth/2

        
        let startAngle = 3 * pi / 2
        let endAngle = 7 * pi / 2
        
        var amount = 0
        var valueArray = [Int]()
        for object in data!.values {
            amount += object
            valueArray.append(object)
        }
        
        let bigAngle = 2 * pi
        let subAngle = bigAngle / CGFloat(amount)
        
        var startSubAngle = startAngle
        var endSubAngle = startAngle
        
        for (key,value) in data! {
            startSubAngle = endSubAngle
            endSubAngle = startSubAngle + subAngle * CGFloat(value)
            
            let subPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startSubAngle, endAngle: endSubAngle, clockwise: true)
            subPath.lineWidth = arcWidth
            UIColor.randomColor().setStroke()
            subPath.stroke()
            
//            let labelAngle = (endSubAngle - startSubAngle)/2 + startSubAngle - (2 * pi)
            
            let firstPoint = self.center
            
            let firstLabelAngle = startSubAngle - (2 * pi)
            let secondLabelAngle = endSubAngle - (2 * pi)
            
            let secondX = (cos(firstLabelAngle) * min(bounds.width, bounds.height)/2) + min(bounds.width, bounds.height)/2
            let secondY = min(bounds.width, bounds.height)/2 + (sin(firstLabelAngle) * min(bounds.width, bounds.height)/2)
            let secondPoint = CGPoint(x: secondX, y: secondY)
        
            
            print("\(secondX) - \(secondY)")
        }
    }
}

class BarChart: UIView {
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }

    override func drawRect(rect: CGRect) {
        
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
