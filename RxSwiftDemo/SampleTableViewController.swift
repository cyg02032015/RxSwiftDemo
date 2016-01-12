//
//  SampleTableViewController.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/12.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
class SampleTableViewController: UIViewController {
  
  var tableView: UITableView!
  var viewModel = SampleViewModel()
  var dataArray = Observable<[SampleModel]?>.empty()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: CGRectZero, style: .Plain)
    view.addSubview(tableView)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    tableView.snp_makeConstraints { make in
      make.top.left.right.bottom.equalTo(view)
    }
//    tableView.delegate = self
//    tableView.dataSource = self
    tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "Cell")
    viewModel.requestData()
    
    dataArray = viewModel.model.map{$0}
//    viewModel.model.subscribeNext { (array) -> Void in
//      Log.YGLog(array)
//      self.dataArray = array
//      self.tableView.reloadData()
//    }.addDisposableTo(disposeBag)

    viewModel.model.map {$0}.bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: CustomCell.self)) { row, item, cell in
        cell.titleLabel.text = item.id
        cell.contentLabel.text = item.title
        cell.imgView.kf_setImageWithURL(NSURL(string: item.image)!, placeholderImage: UIImage(named: "0"))
    }.addDisposableTo(disposeBag)
    tableView.rx_itemSelected.subscribeNext { indexPath in
      Log.YGLog("Selected \(indexPath.row)")
    }.addDisposableTo(disposeBag)
  }
}

//extension SampleTableViewController: UITableViewDataSource, UITableViewDelegate {
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return dataArray.count
//  }
//  
//  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
//    cell.titleLabel.text = dataArray[indexPath.row].id
//    cell.contentLabel.text = dataArray[indexPath.row].title
//    cell.imgView.kf_setImageWithURL(NSURL(string: dataArray[indexPath.row].image)!, placeholderImage: UIImage(named: "0"))
//    return cell
//  }
//}
