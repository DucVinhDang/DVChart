//
//  ViewController.swift
//  DVChart
//
//  Created by Vinh Dang Duc on 7/2/15.
//  Copyright © 2015 Vinh Dang Duc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var data: [String: Int] = [
//        "Rất tồi" : 12,
//        "Tồi" : 30,
//        "Hơi tệ" : 25,
//        "Bình thường" : 10,
//        "Khá tốt" : 23,
//        "Tốt" : 14,
//        "Rất tốt" : 24
//    ]
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let myChart = DVChart(target: self, frame: CGRect(x: 0, y: 0, width: deviceWidth - 40, height: 300), type: .PieChart, data: data)
//        myChart.view.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
//        myChart.show()
//        chart = myChart
        
        let myChart = DVChart(target: self, frame: CGRect(x: 0, y: 0, width: deviceWidth - 40, height: 400), type: .BarChart, data: data)
        myChart.view.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
        myChart.show()
        chart = myChart
        
//        let myChart = DVChart(target: self, frame: CGRect(x: 0, y: 0, width: deviceWidth - 40, height: 400), type: .LineChart, data: data)
//        myChart.view.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
//        myChart.show()
//        chart = myChart
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchAction(sender: AnyObject) {
        for key in self.data.keys {
            data[key] = Int(arc4random()%30)
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
