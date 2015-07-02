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
    
    var data: [String: Int] = [
        "1996" : 5,
        "1997" : 6,
        "1998" : 4,
        "1999" : 7,
        "2000" : 3,
        "2001" : 2
    ]
    
    // MARK: - Init Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(target: UIViewController,frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.target = target
        self.chartFrame = frame
        
        setupChart()
    }
    
    init(target: UIViewController, frame: CGRect, type: ChartType) {
        super.init(nibName: nil, bundle: nil)
        self.target = target
        self.chartFrame = frame
        self.chartType = type
        
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
            pieChart = PieChart(frame: chartFrame, data: data)
            break
        case .BarChart:
            barChart = BarChart(frame: chartFrame)
            break
        case.LineChart:
            lineChart = LineChart(frame: chartFrame)
            break
        default:
            print("Printed something...")
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
        default:
            print("Printed something...")
            break
        }
    }
}

class PieChart: UIView {
    
    var data: [String:Int]?
    let arcWidth: CGFloat = 100.0
    let pi: CGFloat = CGFloat(M_PI)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame)
        self.data = data
        setNeedsDisplay()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        for value in valueArray {
            startSubAngle = endSubAngle
            endSubAngle = startSubAngle + subAngle * CGFloat(value)
            
            let subPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startSubAngle, endAngle: endSubAngle, clockwise: true)
            subPath.lineWidth = arcWidth
            UIColor.randomColor().setStroke()
            subPath.stroke()
        }
    }
}

class BarChart: UIView {
    override func drawRect(rect: CGRect) {
        
    }
}

class LineChart: UIView {
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
