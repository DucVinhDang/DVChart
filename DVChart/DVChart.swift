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
        
        switch chartType {
        case .PieChart:
            let chartSize = min(chartFrame.width, chartFrame.height)
            pieChart = PieChart(frame: CGRect(x: 0, y: 0, width: chartSize, height: chartSize), data: data!)
            pieChart?.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
            view.addSubview(pieChart!)
            
            currentChart = pieChart
            break
        case .BarChart:
            barChart = BarChart(frame: CGRect(x: 0, y: 0, width: chartFrame.width, height: chartFrame.height), data: data!)
            barChart?.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
            view.addSubview(barChart!)
            
            currentChart = barChart
            break
        case.LineChart:
            lineChart = LineChart(frame: CGRect(x: 0, y: 0, width: chartFrame.width, height: chartFrame.height), data: data!)
            view.addSubview(lineChart!)
            
            currentChart = lineChart
            break
        }
    }
    
    // MARK: - Chart Animations
    
    func show() {
        if currentChart == nil { return }
        else {
            if view.superview == nil {
                currentChart?.translatesAutoresizingMaskIntoConstraints = false
                
                if currentChart == pieChart {
                    let chartSize = min(chartFrame.width, chartFrame.height)
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: chartSize))
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: chartSize))
                } else {
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: currentChart!, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
                }
                
                target.view.translatesAutoresizingMaskIntoConstraints = true
                
                target.addChildViewController(self)
                target.view.addSubview(self.view)
                self.didMoveToParentViewController(target)
            } else {
                showChart(currentChart)
                currentChart.setNeedsDisplay()
            }
        }
    }
    
    private func showChart(chart: UIView) {
        if chart.hidden { chart.hidden = false }
    }
    
    func hide() {
        if currentChart == nil { return }
        currentChart.hidden = true
    }
}

//---------------------------------------------------------------//
//-------------------------- PIECHART ---------------------------//
//---------------------------------------------------------------//

class PieChart: UIView {
    
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }
    
    var labelArray = [UILabel]()
    var arcWidth: CGFloat = 130
    let pi: CGFloat = CGFloat(M_PI)
    
    var colorTable = [
        UIColor(red: 0.322, green: 0.886, blue: 0.965, alpha: 1.0),
        UIColor(red: 0.949, green: 0.475, blue: 0.475, alpha: 1.0),
        UIColor(red: 0.788, green: 0.561, blue: 0.949, alpha: 1.0),
        UIColor(red: 0.451, green: 0.918, blue: 0.741, alpha: 1.0),
        UIColor(red: 0.976, green: 0.6, blue: 0.808, alpha: 1.0),
        UIColor(red: 0.6, green: 0.702, blue: 0.976, alpha: 1.0),
        UIColor(red: 0.882, green: 0.882, blue: 0.545, alpha: 1.0),
        UIColor(red: 0.58, green: 0.263, blue: 0.267, alpha: 1.0),
        UIColor(red: 0.91, green: 0.518, blue: 0.447, alpha: 1.0),
        UIColor(red: 0.69, green: 0.878, blue: 0.902, alpha: 1.0)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        setupArcWidth()
    }
    
    init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
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
        
        if data == nil { return }
        
        let cornerPath = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8, height: 8))
        cornerPath.addClip()
        cornerPath.closePath()
        
//        let context = UIGraphicsGetCurrentContext()
//        let colors = [UIColor.randomColor().CGColor, UIColor.randomColor().CGColor]
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colorLocations:[CGFloat] = [0.0, 1.0]
//        let gradient = CGGradientCreateWithColors(colorSpace,
//            colors,
//            colorLocations)
//        let startPoint = CGPoint.zero
//        let endPoint = CGPoint(x:0, y:self.bounds.height)
//        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        
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
        
        var count = 0
        
        for (key,value) in data! {
            startSubAngle = endSubAngle
            endSubAngle = startSubAngle + subAngle * CGFloat(value)
            
            let subPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startSubAngle, endAngle: endSubAngle, clockwise: true)
            subPath.lineWidth = arcWidth
            colorTable[count].setStroke()
            subPath.stroke()

            addLabelToChartPiece("\(key): \(String(value))%", startAngle: startSubAngle, endAngle: endSubAngle)
            count++
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
        let textSize: CGSize = myText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)])
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height))
        label.center = labelCenter
        label.backgroundColor = UIColor.clearColor()
        label.layer.shadowOpacity = 0.2
        label.text = text
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Helvetica", size: 13)
        label.textAlignment = NSTextAlignment.Center
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 5
        
        labelArray.append(label)
        
        self.addSubview(label)
    }
}

//---------------------------------------------------------------//
//-------------------------- BARCHART ---------------------------//
//---------------------------------------------------------------//

class BarChart: AxesChart {
    
    let columnColor = UIColor(red: 0.18, green: 0.737, blue: 0.949, alpha: 1.0)
    let topBackgroundColor = UIColor(red: 0.788, green: 0.933, blue: 0.992, alpha: 1.0)
    let bottomBackgroundColor = UIColor(red: 0.106, green: 0.706, blue: 0.933, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }
    
    override init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame, data: data)
        setupChart()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupChart() {
        super.setupChart()
        self.columnDashedSize = CGSize(width: 6, height: 1)
        self.backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let cornerPath = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8, height: 8))
        cornerPath.addClip()
        cornerPath.closePath()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [topBackgroundColor.CGColor, bottomBackgroundColor.CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        //CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        
        // Let's begin !!!
        
        removeAllLabelArrays()
        createColumnKeyLabels()
        columnKeyLabelsMaxHeight = getMaxHeightOfColumnKeyLabels()
        
        // Step 2: Drawing dashed of chart
        
//        for i in 0..<data!.count {
//            addDashedForColumnOfBarChartAtIndex(index: i)
//        }
        
        // Step 1: Drawing columns of chart
        
        let horizontalY = self.bounds.height - margin.y - columnKeyLabelsMaxHeight
        let columnWidth = getColumnWidth()
        let columnPath = UIBezierPath()
        
        for i in 0..<data!.count {
            let originPosition = getOriginPositionOfColumn(i)
            //addValueLabelOfColumnAtIndex(index: i)
            columnPath.moveToPoint(CGPoint(x: originPosition.x, y: horizontalY))
            columnPath.addLineToPoint(CGPoint(x: originPosition.x, y: originPosition.y))
            columnPath.addLineToPoint(CGPoint(x: originPosition.x + columnWidth, y: originPosition.y))
            columnPath.addLineToPoint(CGPoint(x: originPosition.x + columnWidth, y: horizontalY))
        }
        
            // Add clipping path inside the chart
        
        CGContextSaveGState(context)
        
        let clippingPath = columnPath.copy() as! UIBezierPath
        clippingPath.addLineToPoint(CGPoint(x: getOriginPositionOfColumn(0).x, y: self.bounds.height - margin.y - columnKeyLabelsMaxHeight))
        clippingPath.closePath()
        clippingPath.addClip()
        
        let dataValues: [Int] = [Int](data!.values)
        
        let maxValue = dataValues.reduce(Int.min, combine: { max($0, $1) })
        var indexOfMaxValue = 0
        for i in 0..<dataValues.count {
            if dataValues[i] == maxValue {
                indexOfMaxValue = i
                break
            }
        }
        
        let startP = CGPoint(x: getOriginPositionOfColumn(indexOfMaxValue).x, y: getOriginPositionOfColumn(indexOfMaxValue).y)
        let endP = CGPoint(x: getOriginPositionOfColumn(indexOfMaxValue).x, y: self.bounds.height - margin.y - columnKeyLabelsMaxHeight)
        
        let clippingPathColors = [topBackgroundColor.CGColor, bottomBackgroundColor.CGColor]
        let clippingPathGradient = CGGradientCreateWithColors(colorSpace,
            clippingPathColors,
            colorLocations)
        CGContextDrawLinearGradient(context, clippingPathGradient, startP, endP, CGGradientDrawingOptions.DrawsAfterEndLocation)
        CGContextRestoreGState(context)
        
        // Finish the chart
        
        for i in 0..<data!.count {
            addValueLabelOfColumnAtIndex(index: i)
        }
        
        columnPath.closePath()
        
//        columnPath.closePath()
//        UIColor.randomColor().setFill()
//        columnPath.fill()
        
        // Step 3: Drawing axes of chart
        
            // Draw the vertical axis
        
        let axesPath = UIBezierPath()
        axesPath.moveToPoint(CGPoint(x: margin.x, y: margin.y))
        axesPath.addLineToPoint(CGPoint(x: margin.x-arrowAxesSizeX, y: margin.y+arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: margin.x, y: margin.y))
        axesPath.addLineToPoint(CGPoint(x: margin.x+arrowAxesSizeX, y: margin.y+arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: margin.x, y: margin.y))
        axesPath.addLineToPoint(CGPoint(x: margin.x, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight))
        
            // Draw the horizontal axis
        
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin.x, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight))
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin.x-arrowAxesSizeX, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight-arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: self.bounds.width-margin.x, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight))
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin.x-arrowAxesSizeX, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight+arrowAxesSizeY))
        
        for i in 0..<data!.count {
            let columnPosition = getOriginPositionOfColumn(i)
            let startPointX = columnPosition.x + columnWidth/2
            let startPointY = self.bounds.height - margin.y - columnKeyLabelsMaxHeight
            axesPath.moveToPoint(CGPoint(x: startPointX, y: startPointY))
            axesPath.addLineToPoint(CGPoint(x: startPointX, y: startPointY + (horizontalAxisTinyLineWidth/2)))
        }
        
        axesPath.lineWidth = axesLineWidth
        axesColor.setStroke()
        axesPath.stroke()
        axesPath.closePath()
        
        
        
            // Draw the circle for root point of axes
        
        addCircleForRootPointOfAxes()
        
        // Step 4: Draw the column key labels
        
        setPositionAgainAndAddColumnKeyLabelsToView()
    }
    
    func addDashedForColumnOfBarChartAtIndex(index index: Int) {
        let columnPosition = getOriginPositionOfColumn(index)
        var pointX = columnPosition.x
        let pointY = columnPosition.y + columnDashedSize.height
        let dashedPath = UIBezierPath()
        
        var canDraw = true
        while canDraw {
            var dashedWidth = columnDashedSize.width
            if pointX < margin.x {
                dashedWidth = 0
                canDraw = false
            } else if pointX - dashedWidth < margin.x {
                dashedWidth = pointX - margin.x
                canDraw = false
            }
            dashedPath.moveToPoint(CGPoint(x: pointX, y: pointY))
            dashedPath.addLineToPoint(CGPoint(x: pointX - dashedWidth, y: pointY))
            pointX -= dashedWidth + distanceBetweenDashed
        }
        dashedPath.lineWidth = columnDashedSize.height
        columnDashedColor.setStroke()
        dashedPath.stroke()
        dashedPath.closePath()
    }
    
}

//---------------------------------------------------------------//
//------------------------- LINECHART ---------------------------//
//---------------------------------------------------------------//

class LineChart: AxesChart {
    let columnCircleRadius: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }
    
    override init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame, data: data)
        setupChart()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupChart() {
        super.setupChart()
        self.columnDashedSize = CGSize(width: 1, height: 6)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let cornerPath = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8, height: 8))
        cornerPath.addClip()
        cornerPath.closePath()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [UIColor.randomColor().CGColor, UIColor.randomColor().CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        // Let's begin !!!
        
        removeAllLabelArrays()
        createColumnKeyLabels()
        columnKeyLabelsMaxHeight = getMaxHeightOfColumnKeyLabels()
        
        // Step 1: Drawing columns of chart and column value labels
        
        let originPosition = getOriginPositionOfColumn(0)
        let columnWidth = getColumnWidth()
        
        let columnPath = UIBezierPath()
        columnPath.moveToPoint(CGPoint(x: originPosition.x + columnWidth/2, y: originPosition.y))
        
        for i in 0..<data!.count {
            if i+1 < data!.count {
                let nextColumPosition = getOriginPositionOfColumn(i+1)
                let pointX = nextColumPosition.x + columnWidth/2
                let pointY = nextColumPosition.y
                columnPath.addLineToPoint(CGPoint(x: pointX, y: pointY))
            }
        }
        
            // Add clipping path inside the chart
        
        CGContextSaveGState(context)
    
        let clippingPath = columnPath.copy() as! UIBezierPath
        clippingPath.addLineToPoint(CGPoint(x: getOriginPositionOfColumn(data!.count-1).x + columnWidth/2, y: self.bounds.height - margin.y - columnKeyLabelsMaxHeight))
        clippingPath.addLineToPoint(CGPoint(x: getOriginPositionOfColumn(0).x + columnWidth/2, y: self.bounds.height - margin.y - columnKeyLabelsMaxHeight))
        clippingPath.closePath()
        clippingPath.addClip()
        
        let dataValues: [Int] = [Int](data!.values)
        
        let maxValue = dataValues.reduce(Int.min, combine: { max($0, $1) })
        var indexOfMaxValue = 0
        for i in 0..<data!.values.count {
            if dataValues[i] == maxValue {
                indexOfMaxValue = i
                break
            }
        }
        
        let startP = CGPoint(x: getOriginPositionOfColumn(indexOfMaxValue).x, y: getOriginPositionOfColumn(indexOfMaxValue).y)
        let endP = CGPoint(x: getOriginPositionOfColumn(indexOfMaxValue).x, y: self.bounds.height - margin.y - columnKeyLabelsMaxHeight)
        
        CGContextDrawLinearGradient(context, gradient, startP, endP, CGGradientDrawingOptions.DrawsAfterEndLocation)
        CGContextRestoreGState(context)
        
            // Finish the chart
        
        columnPath.lineWidth = lineBetweenColumnsWidth
        lineBetweenColumnsColor.setStroke()
        columnPath.stroke()
        
        columnPath.closePath()
        
        for i in 0..<data!.count {
            addCircleForColumnAtIndex(index: i)
            addDashedForColumnOfLineChartAtIndex(index: i)
            addValueLabelOfColumnAtIndex(index: i)
        }
        
        // Step 2: Drawing axes of chart
        
            // Draw the vertical axis
        
        let axesPath = UIBezierPath()
        axesPath.moveToPoint(CGPoint(x: margin.x, y: margin.y))
        axesPath.addLineToPoint(CGPoint(x: margin.x-arrowAxesSizeX, y: margin.y+arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: margin.x, y: margin.y))
        axesPath.addLineToPoint(CGPoint(x: margin.x+arrowAxesSizeX, y: margin.y+arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: margin.x, y: margin.y))
        axesPath.addLineToPoint(CGPoint(x: margin.x, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight))
        
            // Draw the horizontal axis
        
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin.x, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight))
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin.x-arrowAxesSizeX, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight-arrowAxesSizeY))
        axesPath.moveToPoint(CGPoint(x: self.bounds.width-margin.x, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight))
        axesPath.addLineToPoint(CGPoint(x: self.bounds.width-margin.x-arrowAxesSizeX, y: self.bounds.height-margin.y-columnKeyLabelsMaxHeight+arrowAxesSizeY))
        
        for i in 0..<data!.count {
            let columnPosition = getOriginPositionOfColumn(i)
            let startPointX = columnPosition.x + columnWidth/2
            let startPointY = self.bounds.height - margin.y - columnKeyLabelsMaxHeight
            axesPath.moveToPoint(CGPoint(x: startPointX, y: startPointY - (horizontalAxisTinyLineWidth/2)))
            axesPath.addLineToPoint(CGPoint(x: startPointX, y: startPointY + (horizontalAxisTinyLineWidth/2)))
        }
        
        axesPath.lineWidth = axesLineWidth
        axesColor.setStroke()
        axesPath.stroke()
        axesPath.closePath()
        
        // Draw the circle for root point of axes
        
        addCircleForRootPointOfAxes()
        
        // Step 3: Draw the column key labels
        
        setPositionAgainAndAddColumnKeyLabelsToView()

    }

    func addCircleForColumnAtIndex(index index: Int) {
        let columnPosition = getOriginPositionOfColumn(index)
        let columnWidth = getColumnWidth()
        let pointX = columnPosition.x + columnWidth/2
        let pointY = columnPosition.y
        let circlePath = UIBezierPath(ovalInRect: CGRect(x: pointX - columnCircleRadius, y: pointY - columnCircleRadius, width: columnCircleRadius*2, height: columnCircleRadius*2))
        lineBetweenColumnsColor.setFill()
        circlePath.fill()
        circlePath.closePath()
    }
    
    func addDashedForColumnOfLineChartAtIndex(index index: Int) {
        let columnPosition = getOriginPositionOfColumn(index)
        let columnWidth = getColumnWidth()
        let pointX = columnPosition.x + columnWidth/2
        var pointY = columnPosition.y
        let dashedPath = UIBezierPath()
        
        
        var canDraw = true
        while canDraw {
            var dashedHeight = columnDashedSize.height
            if pointY > self.bounds.height - margin.y - columnKeyLabelsMaxHeight {
                dashedHeight = 0
                canDraw = false
            } else if pointY + dashedHeight > self.bounds.height - margin.y - columnKeyLabelsMaxHeight {
                dashedHeight = self.bounds.height - margin.y - columnKeyLabelsMaxHeight - pointY
                canDraw = false
            }
            dashedPath.moveToPoint(CGPoint(x: pointX, y: pointY))
            dashedPath.addLineToPoint(CGPoint(x: pointX, y: pointY + dashedHeight))
            pointY += dashedHeight + distanceBetweenDashed
        }
        
        dashedPath.lineWidth = columnDashedSize.width
        columnDashedColor.setStroke()
        dashedPath.stroke()
        dashedPath.closePath()
    }
}

//---------------------------------------------------------------//
//------------------------- AXESCHART ---------------------------//
//---------------------------------------------------------------//

class AxesChart: UIView {
    
    // MARK: - Properties
    
    var data: [String:Int]? {
        didSet { setNeedsDisplay() }
    }
    
    var verticalAxisLabels = [UILabel]()
    var horizontalAxisLabels = [UILabel]()
    var columnValueLabels = [UILabel]()
    var columnKeyLabels = [UILabel]()
    
    var margin: CGPoint = CGPoint(x: 15, y: 10)
    let axesLineWidth: CGFloat = 1
    var columnDashedSize = CGSize(width: 0.5, height: 6)
    let lineBetweenColumnsWidth: CGFloat = 2
    let distanceBetweenColumns = 10
    let distanceBetweenDashed: CGFloat = 4
    let verticalAxisTinyLineWidth: CGFloat = 4
    let horizontalAxisTinyLineWidth: CGFloat = 4
    let arrowAxesSizeX: CGFloat = 3
    let arrowAxesSizeY: CGFloat = 3
    let distanceBetweenHorizontalAxisAndKeyLabels: CGFloat = 8
    var columnKeyLabelsMaxHeight: CGFloat = 0
    
    let axesColor = UIColor.blackColor()
    let columnDashedColor = UIColor.whiteColor()
    let columnValueLabelColor = UIColor.blackColor()
    let columnKeyLabelColor = UIColor.blackColor()
    let lineBetweenColumnsColor = UIColor.whiteColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }
    
    init(frame: CGRect, data: [String:Int]) {
        super.init(frame: frame)
        setupChart()
        self.data = data
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupChart() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        if data == nil { return }
        margin = getMarginOfChart()
    }
    
    func getMarginOfChart() -> CGPoint {
        var value: CGPoint = CGPointZero
//        if UIDevice.currentDevice().orientation.isPortrait.boolValue {
//            value = self.bounds.width/15
//        } else if UIDevice.currentDevice().orientation.isLandscape.boolValue {
//            value = self.bounds.height/10
//        }
        if UIDevice.currentDevice().orientation.isPortrait.boolValue {
            value = CGPoint(x: 15, y: 10)
        } else if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            value = CGPoint(x: 15, y: 15)
        }
        return value
    }
    
    func getOriginPositionOfColumn(index: Int) -> CGPoint {
        let dataValues: [Int] = [Int](data!.values)
        let maxValue = dataValues.reduce(Int.min, combine: { max($0, $1) })
        let columnValue = getTheColumnValue(column: index)
        let columnWidth = getColumnWidth()
        let chartHeight = self.bounds.height - (2 * columnKeyLabelsMaxHeight) - (2 * margin.y)
        
        let posX = margin.x + CGFloat((distanceBetweenColumns * (index + 1))) + (columnWidth * CGFloat(index))
        let posY = margin.y + columnKeyLabelsMaxHeight + (chartHeight - (CGFloat(columnValue)/CGFloat(maxValue)) * chartHeight)
        return CGPoint(x: posX, y: posY)
    }
    
    func getColumnWidth() -> CGFloat {
        let dataCount = data!.count
        let chartWidth = self.bounds.width - (2 * margin.x)
        return (chartWidth - CGFloat((distanceBetweenColumns * (dataCount+1)))) / CGFloat(dataCount)
    }
    
    func getColumnHeightAtIndex(columnIndex columnIndex:Int) -> CGFloat {
        let columnPosition = getOriginPositionOfColumn(columnIndex)
        return self.bounds.height - columnPosition.y - margin.y - columnKeyLabelsMaxHeight - distanceBetweenHorizontalAxisAndKeyLabels
    }
    
    func getTheColumnValue(column column: Int) -> Int {
        let dataValues: [Int] = [Int](data!.values)
        return dataValues[column]
    }
    
    func getTheTotalAmountOfData() -> Int {
        var amount = 0
        for object in data!.values { amount += object }
        return amount
    }
    
    func createColumnKeyLabels() {
        let columnWidth = getColumnWidth()
        let dataKeys: [String] = [String](data!.keys)
        
        for i in 0..<dataKeys.count {
            let columnPosition = getOriginPositionOfColumn(i)
            let posX = columnPosition.x
            let posY = self.bounds.height - margin.y
            let label:UILabel = UILabel(frame: CGRectMake(posX, posY, columnWidth, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = UIFont(name: "Helvetica", size: 11)
            label.text = dataKeys[i]
            label.textAlignment = .Center
            label.sizeToFit()
            label.center = CGPoint(x: posX + columnWidth/2, y: label.frame.origin.y + label.frame.height/2)
            columnKeyLabels.append(label)
        }
    }
    
    func getMaxHeightOfColumnKeyLabels() -> CGFloat {
        var value: CGFloat = 0
        for label in columnKeyLabels {
            if label.bounds.height > value {
                value = label.frame.height
            }
        }
        return value + distanceBetweenHorizontalAxisAndKeyLabels
    }
    
    func setPositionAgainAndAddColumnKeyLabelsToView() {
        for label in columnKeyLabels {
            label.frame.origin = CGPoint(x: label.frame.origin.x, y: self.bounds.height - margin.y - columnKeyLabelsMaxHeight + distanceBetweenHorizontalAxisAndKeyLabels)
            self.addSubview(label)
        }
    }
    
    func addValueLabelOfColumnAtIndex(index index:Int) {
        let columnPosition = getOriginPositionOfColumn(index)
        let columnHeight = getColumnHeightAtIndex(columnIndex: index)
        let labelOriginPoint = CGPoint(x: columnPosition.x, y: columnPosition.y + columnHeight/2)
        let dataValues: [Int] = [Int](data!.values)
        
        let text = String(dataValues[index])
        let myText: NSString = text as NSString
        let textSize: CGSize = myText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)])
        
        let label = UILabel(frame: CGRect(x: labelOriginPoint.x + getColumnWidth()/2 - textSize.width/2, y: labelOriginPoint.y, width: textSize.width, height: textSize.height))
        label.text = text
        label.font = UIFont(name: "Helvetica", size: 12)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center

//        label.backgroundColor = UIColor.redColor()
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = min(label.frame.width, label.frame.height)/2
        
        self.addSubview(label)
        columnValueLabels.append(label)
    }
    
    func addCircleForRootPointOfAxes() {
        let rootCircleWidth: CGFloat = 6
        let rootCircleHeight: CGFloat = 6
        let rootCircleX = margin.x - rootCircleWidth/2
        let rootCircleY = self.bounds.height - margin.y - columnKeyLabelsMaxHeight - rootCircleHeight/2
        
        let rootCirclePath = UIBezierPath(ovalInRect: CGRect(x: rootCircleX, y: rootCircleY, width: rootCircleWidth, height: rootCircleHeight))
        axesColor.setFill()
        rootCirclePath.fill()
        rootCirclePath.closePath()
    }
    
    func removeAllLabelArrays() {
        for label in verticalAxisLabels { label.removeFromSuperview() }
        verticalAxisLabels.removeAll()
        
        for label in horizontalAxisLabels { label.removeFromSuperview() }
        horizontalAxisLabels.removeAll()
        
        for label in columnKeyLabels { label.removeFromSuperview() }
        columnKeyLabels.removeAll()
        
        for label in columnValueLabels { label.removeFromSuperview() }
        columnValueLabels.removeAll()
    }
}

//---------------------------------------------------------------//
//------------------------- EXTENSION ---------------------------//
//---------------------------------------------------------------//

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}