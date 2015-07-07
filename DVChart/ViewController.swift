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
    
    let array = ["Piechart", "Barchart", "Linechart"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DVChart"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = array[indexPath.row]
        cell.detailTextLabel?.text = "Chart number \(indexPath.row + 1)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let pieChartVC = PieChartVC(nibName: "PieChartVC", bundle: nil)
            self.navigationController?.pushViewController(pieChartVC, animated: true)
            break
        case 1:
            let barChartVC = BarChartVC(nibName: "BarChartVC", bundle: nil)
            self.navigationController?.pushViewController(barChartVC, animated: true)
            break
        case 2:
            let lineChartVC = LineChartVC(nibName: "LineChartVC", bundle: nil)
            self.navigationController?.pushViewController(lineChartVC, animated: true)
            break
        default:
            break
        }
    }
}