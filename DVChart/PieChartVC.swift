//
//  PieChartVC.swift
//  DVChart
//
//  Created by Vinh Dang Duc on 7/6/15.
//  Copyright © 2015 Vinh Dang Duc. All rights reserved.
//

import UIKit

class PieChartVC: UIViewController {

    var data: [String: Int] = [
        "2001" : 12,
        "2002" : 30,
        "2003" : 25,
        "2004" : 10,
        "2005" : 23,
        "2006" : 14,
        "2007" : 24
    ]
    
    weak var chart: DVChart?
    
    let deviceWidth = UIScreen.mainScreen().bounds.size.width
    let deviceHeight = UIScreen.mainScreen().bounds.size.height

    let margin: CGFloat = 20
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Piechart"
        
        let myChart = DVChart(target: self, frame: CGRect(x: margin, y: margin, width: deviceWidth - (margin * 2), height: 210), type: .PieChart, data: data)
        myChart.view.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
        
        view.addConstraint(NSLayoutConstraint(item: myChart.view, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: myChart.view, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: myChart.view, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin))
        view.addConstraint(NSLayoutConstraint(item: myChart.view, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -margin))
        view.addConstraint(NSLayoutConstraint(item: myChart.view, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 210))
        
        myChart.show()
        chart = myChart
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceRotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deviceRotated() {
        chart?.currentChart.setNeedsDisplay()
    }
    
    @IBAction func touchAction(sender: AnyObject) {
        for key in self.data.keys {
            data[key] = 10 + Int(arc4random()%30)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.chart?.view.alpha = 0
            }, completion: { finished in
                UIView.animateWithDuration(0.2, animations: {
                    self.chart?.data = self.data
                    self.chart?.view.alpha = 1
                })
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
