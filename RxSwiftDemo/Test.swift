//
//  Test.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/11.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import Foundation
import RxSwift
class Test {
  func observe() {
//    let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//    v.backgroundColor = UIColor.yellowColor()
//    view.addSubview(v)
//    v.rx_observe(CGRect.self, "frame").subscribeNext{ frame in
//      Log.YGLog(frame)
//      }.addDisposableTo(disposeBag)
//    self.rx_observe(CGRect.self, "textField.frame", retainSelf: false).subscribeNext {
//      frame in
//      Log.YGLog(frame)
//      }.addDisposableTo(disposeBag)
  }
  
  func variable() {
    let variable = Variable(0)
    _ = variable.asObservable().subscribe(onNext: {n in
      Log.YGLog("First \(n)")
      }, onError: {error in
        Log.YGLog(error)
      }, onCompleted: {
        Log.YGLog("Completed 1")
    })
    
    Log.YGLog("Before send1")
    
    variable.value = 1
    
    Log.YGLog("Before second subscription")
    
    _ = variable.asObservable().subscribe(onNext: { n in
      Log.YGLog("Second \(n)")
      }, onCompleted: {
        Log.YGLog("Completed 2")
    })
    
    variable.value = 2
    Log.YGLog("End ---")
  }
  
  func counter() {
    let counter = myTimerInterval(0.1)
    Log.YGLog("Started ----")
    let subscription = counter.subscribeNext {
      Log.YGLog($0)
    }
    NSThread.sleepForTimeInterval(1)
    subscription.dispose()
    Log.YGLog("Ended---")
  }
  
  func myTimerInterval(interval: NSTimeInterval) -> Observable<Int> {
    return Observable.create { observer in
      Log.YGLog("Subscription")
      let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
      
      var next = 0
      
      dispatch_source_set_timer(timer, 0, UInt64(interval * Double(NSEC_PER_SEC)), 0)
      let cancel = AnonymousDisposable {
        Log.YGLog("Disposed")
        dispatch_source_cancel(timer)
      }
      
      dispatch_source_set_event_handler(timer) {
        if cancel.disposed {
          return
        }
        observer.on(.Next(next))
        next++
      }
      dispatch_resume(timer)
      return cancel
    }
  }
}