//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/7.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
let disposeBag = DisposeBag()
let url = "http://news-at.zhihu.com/api/4/news/latest"

class ViewController: UIViewController {
  let dataArray = Observable.just(["Login", "SampleTableView"])
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    automaticallyAdjustsScrollViewInsets = false
    

    dataArray.bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { row, item, cell in
      cell.textLabel?.text = item
    }.addDisposableTo(disposeBag)
    
    tableView.rx_itemSelected.subscribeNext { e in
      switch e.row {
      case 0:
        let logVC = LogViewController()
        self.navigationController?.pushViewController(logVC, animated: true)
      case 1:
        let sampleVC = SampleTableViewController()
        self.navigationController?.pushViewController(sampleVC, animated: true)
      default:
        ""
      }
    }.addDisposableTo(disposeBag)
    
  }
}