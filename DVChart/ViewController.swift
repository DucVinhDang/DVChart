//
//  ViewController.swift
//  DVChart
//
//  Created by Vinh Dang Duc on 7/2/15.
//  Copyright © 2015 Vinh Dang Duc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data: [String: Int] = [
        "1996" : 5,
        "1997" : 6,
        "1998" : 4,
        "1999" : 7,
        "2000" : 3,
        "2001" : 2,
        "2002" : 4,
        "2003" : 6
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = DVChart(target: self, frame: CGRect(x: 0, y: 0, width: 340, height: 340), type: .PieChart, data: data)
        chart.show()
        // Do any additional setup after loading the view.
        print("\(view.bounds.width)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
