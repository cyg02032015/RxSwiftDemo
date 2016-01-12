//
//  SampleViewModel.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/12.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import SwiftyJSON

struct SampleViewModel {
  
  var model = PublishSubject<[SampleModel]>()
  
  mutating func requestData() {
    Alamofire.request(.GET, url).rx_responseJSON()
      .subscribe(onNext: { data in
        var array = [SampleModel]()
        let json = JSON(data)
        let stories = json["stories"].arrayValue
        for item in stories {
          array.append(SampleModel(json: item))
        }
        self.model.on(.Next(array))
        self.model.onCompleted()
        }, onError: { error in
          Log.YGLog(error)
        }, onCompleted: { () -> Void in
          Log.YGLog("On Completed")
      }).addDisposableTo(disposeBag)
  }
}

