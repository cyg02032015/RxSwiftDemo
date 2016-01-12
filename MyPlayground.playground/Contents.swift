//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import XCPlayground
import RxCocoa
typealias Task = (cancel: Bool) -> ()

func delay(time: NSTimeInterval, task:() -> ()) -> Task?{
  func dispatch_later(block: () -> ()){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
  }
  var closure: dispatch_block_t? = task
  var result: Task?
  let delayClosure: Task = {
    cancel in
    if let internalClosure = closure {
      if cancel == false {
        dispatch_async(dispatch_get_main_queue(), internalClosure)
      }
    }
    closure = nil
    result = nil
  }
  result = delayClosure
  
  dispatch_later { () -> () in
    if let delayClosure = result {
      delayClosure(cancel: false)
    }
  }
  return result
}
func cancel(task: Task?){
  task?(cancel: true)
}



let subscription = Observable<Int>.interval(0.3, scheduler: MainScheduler.instance)
  .observeOn(MainScheduler.instance)
  .subscribe { event in
    print(event)
}


subscription.dispose()


func empty() {
  let emptySequence = Observable<Int>.empty()
  _ = emptySequence.subscribe { (event) -> Void in
    print(event)
  }
}

func never() {
  let neverSequence = Observable<Int>.never()
  _ = neverSequence.subscribe({ (event) -> Void in
    print("This block is never called \(event)")
  })
}

func just() {
  let singleElementSequence = Observable.just(12)
  _ = singleElementSequence.subscribe { event in
    print(event)
  }
}

func sequenceOf() {
  let sequenceOfElements = Observable.of(0,1,2)
  _ = sequenceOfElements.subscribe { event in
    print(event)
  }
}

func from() {
  let sequenceFromArray = ["Tom","Jack","Beatch"].toObservable()
  _ = sequenceFromArray.subscribe { event in
    print(event)
  }
}


func create() {
  let myJust = { (singleElement: Int) -> Observable<Int> in
    return Observable.create({ (observer) -> Disposable in
      observer.on(.Next(singleElement))
      observer.on(.Completed)
      return NopDisposable.instance
    })
  }
  
  _ = myJust(5).subscribe({ event in
    print(event)
  })
}


func failWith() {
  let error = NSError(domain: "Test", code: -1, userInfo: ["Error":"WHY ERROR"])
  let erroredSequence = Observable<Int>.error(error)
  _ = erroredSequence.subscribe({ event in
    print(event)
  })
}

func defferred() {
  let defferedSequence: Observable<Int> = Observable.deferred({
    print("createing defferSequence")
    return Observable.create({ observer in
      print("emmiting")
      observer.on(.Next(0))
      observer.on(.Next(1))
      return NopDisposable.instance
    })
  })
  _ = defferedSequence.subscribe({ event in
    print(event)
  })
  
  _ = defferedSequence.subscribe({ event in
    print(event)
  })
}



// 蒙
func writeSequenceToConsole<O: ObservableType>(name: String, sequence: O) -> Disposable {
  return sequence.subscribe { e in
    print("Subscription: \(name), event: \(e)")
  }
}

func publishSubject() {
  let disposeBag = DisposeBag()
  let subject = PublishSubject<String>()
  writeSequenceToConsole("1", sequence: subject).addDisposableTo(disposeBag)
  subject.on(.Next("a"))
  subject.on(.Next("b"))
  writeSequenceToConsole("2", sequence: subject).addDisposableTo(disposeBag)
  subject.on(.Next("c"))
  subject.on(.Next("d"))
}

func replaySubject() {
  let disposeBag = DisposeBag()
  let replaySubject = ReplaySubject<String>.create(bufferSize: 1)
  writeSequenceToConsole("1", sequence: replaySubject).addDisposableTo(disposeBag)
  replaySubject.on(.Next("A"))
  replaySubject.on(.Next("B"))
  writeSequenceToConsole("2", sequence: replaySubject).addDisposableTo(disposeBag)
  replaySubject.on(.Next("C"))
  replaySubject.on(.Next("D"))
}

func behaviorSubject() {
  let disposeBag = DisposeBag()
  let behaviorSubject = BehaviorSubject(value: "Z")
  writeSequenceToConsole("1", sequence: behaviorSubject).addDisposableTo(disposeBag)
  behaviorSubject.on(.Next("X"))
  behaviorSubject.on(.Next("C"))
  writeSequenceToConsole("2", sequence: behaviorSubject).addDisposableTo(disposeBag)
  behaviorSubject.on(.Next("A"))
  behaviorSubject.on(.Next("E"))
}

func variable() {
  let disposeBag = DisposeBag()
  let variable = Variable("z")
  writeSequenceToConsole("a", sequence: variable.asObservable()).addDisposableTo(disposeBag)
  variable.value = "a"
  variable.value = "b"
  writeSequenceToConsole("b", sequence: variable.asObservable()).addDisposableTo(disposeBag)
  variable.value = "c"
  variable.value = "d"
}

func map() {
  let originalSequence = Observable.of(Character("A"),Character("B"),Character("C"))
  _ = originalSequence.map { char in
    char.debugDescription
    }.subscribe {
      print($0)
  }
}

func flatMap() {
  let sequenceInt = Observable.of(1,2,3)
  let sequenceString = Observable.of("A","B","C","D","--")
  _ = sequenceInt.flatMap{ (x: Int) -> Observable<String> in
    print("From sequenceInt \(x)")
    return sequenceString
    }.subscribe{
      print($0)
  }
}

func scan() {
  let sequenceToSum = Observable.of(0,1,2,3)
  _ = sequenceToSum.scan(0) { acum, elem in
    acum + elem
    }.subscribe {
      print($0)
  }
}

func filter() {
  let filterScription = Observable.of(0,1,2,3,4,5,6,7,8,9)
    .filter {
      $0 % 2 == 0
    }.subscribe {
      print($0)
  }
}
func distinctUntilChange() {
  let distinctUntilChange = Observable.of(1,2,3,1,1,1,4,4)
    .distinctUntilChanged()
    .subscribe {
      print($0)
  }
}

func take() {
  let takeScription = Observable.of(1,2,3,4,5,6)
    .take(3)
    .subscribe {
      print($0)
  }
}

func startWith() {
  let startWithScription = Observable.of(4,5,6,7,8)
    .startWith(3)
    .startWith(2)
    .startWith(0)
    .subscribe {
      print($0)
  }
}

func combineLatest() {
  let intOb1 = PublishSubject<String>()
  let intOb2 = PublishSubject<Int>()
  _ = Observable.combineLatest(intOb1, intOb2) {
    "\($0) \($1)"
    }.subscribe {
      print($0)
  }
  intOb1.on(.Next("A"))
  intOb2.on(.Next(1))
  
  intOb1.on(.Next("B"))
  intOb2.on(.Next(2))
}

func combineLatest2() {
  let justIntOb1 = Observable.just(2)
  let justIntOb2 = Observable.of(0,1,2,3)
  _ = Observable.combineLatest(justIntOb1, justIntOb2) {
    $0 * $1
    }.subscribe {
      print($0)
  }
}

func combineLatest3() {
  let justInt = Observable.just(2)
  let ofIntOb1 = Observable.of(0,1,2)
  let ofIntOb2 = Observable.of(0,1,2,3)
  _ = Observable.combineLatest(justInt, ofIntOb1, ofIntOb2) {
    ($0 + $1) * $2
    }.subscribe {
      print($0)
  }
}

func combineLatest4() {
  let intObJust = Observable.just(2)
  let stringOb = Observable.just("a")
  _ = Observable.combineLatest(intObJust, stringOb) {
    "\($0)" + $1
    }.subscribe {
      print($0)
  }
}

func combineLatest5() {
  let INTOB1 = Observable.just(2)
  let INTOB2 = Observable.of(0,1,2)
  let INTOB3 = Observable.of(0,1,2,3)
  _ = [INTOB1, INTOB2, INTOB3].combineLatest { intArray -> Int in
    Int((intArray[0] + intArray[1]) * intArray[2])
    }.subscribe { event in
      print(event)
  }
}

func zip() {
  let zipOb1 = PublishSubject<String>()
  let zipOb2 = PublishSubject<Int>()
  _ = Observable.zip(zipOb1, zipOb2) {
    "\($0) \($1)"
    }.subscribe {
      print($0)
  }
  
  zipOb1.on(.Next("A"))
  zipOb2.on(.Next(1))
  zipOb1.on(.Next("B"))
  zipOb1.on(.Next("C"))
  zipOb2.on(.Next(3))
}

func zip2() {
  let zipOB1 = Observable.just(2)
  let zipOB2 = Observable.of(0,1,2,3)
  _ = Observable.zip(zipOB1, zipOB2) {
    $0 + $1
    }.subscribe {
      print($0)
  }
}

func zip3() {
  let ZIP1 = Observable.of(0,1)
  let ZIP2 = Observable.of(0,1,2,3)
  let ZIP3 = Observable.of(0,1,2,3,4)
  _ = Observable.zip(ZIP1, ZIP2, ZIP3) {
    ($0 + $1) * $2
    }.subscribe {
      print($0)
  }
}

func merge() {
  let merge1 = PublishSubject<Int>()
  let merge2 = PublishSubject<Int>()
  _ = Observable.of(merge1, merge2)
    .merge()
    .subscribeNext({ (int) -> Void in
      print(int)
    })
  merge1.on(.Next(20))
  merge1.on(.Next(30))
  merge1.on(.Next(10))
  merge2.on(.Next(1))
  merge1.on(.Next(100))
  merge1.on(.Next(80))
  merge2.on(.Next(1))
}

func merge2() {
  let merge1 = PublishSubject<Int>()
  let merge2 = PublishSubject<Int>()
  _ = Observable.of(merge1, merge2)
    .merge(maxConcurrent: 2)
    .subscribeNext({ (int) -> Void in
      print(int)
    })
  merge1.on(.Next(20))
  merge1.on(.Next(30))
  merge1.on(.Next(10))
  merge2.on(.Next(1))
  merge1.on(.Next(100))
  merge1.on(.Next(80))
  merge2.on(.Next(1))
}

func switchLatest() {
  let var1 = Variable(0)
  let var2 = Variable(200)
  let var3 = Variable(var1.asObservable())
  
  _ = var3.asObservable()
    .switchLatest()
    .subscribe {
      print($0)
  }
  var1.value = 1
  var1.value = 2
  var1.value = 4
  var3.value = var2.asObservable()
  var2.value = 100
  var1.value = 5
  var1.value = 10
}

func  catchError() {
  let fails = PublishSubject<Int>()
  let recoverySequence = Observable.of(404)
  _ = fails.catchError { error in
    return recoverySequence
    }.subscribe {
      print($0)
  }
  
  fails.on(.Next(1))
  fails.on(.Next(2))
  fails.on(.Next(3))
  fails.on(.Error(NSError(domain: "Test", code: 0, userInfo: nil)))
  fails.on(.Next(4))
}

func catchErrorJustReturn() {
  let sequenceTahtFails = PublishSubject<Int>()
  _ = sequenceTahtFails.catchErrorJustReturn(403)
    .subscribe( {
      print($0)
    })
  sequenceTahtFails.on(.Next(1))
  sequenceTahtFails.on(.Next(2))
  sequenceTahtFails.on(.Next(3))
  sequenceTahtFails.on(.Next(4))
  sequenceTahtFails.on(.Error(NSError(domain: "Test1", code: 0, userInfo: nil)))
}

func retry() {
  let count = 1
  let funnyLookingSequence = Observable<Int>.create { observer in
    let error = NSError(domain: "Test", code: -1, userInfo: nil)
    observer.on(.Next(0))
    observer.on(.Next(1))
    observer.on(.Next(2))
    if count < 2 {
      observer.on(.Error(error))
    }
    observer.on(.Next(3))
    observer.on(.Next(4))
    observer.on(.Next(5))
    observer.on(.Completed)
    return NopDisposable.instance
  }
  _ = funnyLookingSequence.retry(2)
    .subscribe {
      print($0)
  }
}

func subscribe() {
  let sequenceOfInts = PublishSubject<Int>()
  _ = sequenceOfInts.subscribe {
    print($0)
  }
  sequenceOfInts.on(.Next(1))
  sequenceOfInts.on(.Completed)
}

func subscribeNext() {
  let sequenceOfINTS = PublishSubject<Int>()
  _ = sequenceOfINTS.subscribeCompleted {
    print("It's completed")
  }
  
  sequenceOfINTS.on(.Next(1))
  sequenceOfINTS.on(.Completed)
}

func doon() {
  let doOn = PublishSubject<Int>()
  _ = doOn.doOn {
    print("Intercepted event \($0)")
    }.subscribe {
      print($0)
  }
  
  doOn.on(.Next(1))
  doOn.on(.Completed)
}

func takeUntil() {
  let s = PublishSubject<Int>()
  let whenThisSendsNextWorldStops = PublishSubject<Int>()
  _ = s.takeUntil(whenThisSendsNextWorldStops).subscribe {
    print($0)
  }
  s.on(.Next(1))
  s.on(.Next(2))
  whenThisSendsNextWorldStops.on(.Next(2))
  s.on(.Next(3))
  

}

func takeWhile() {
  let sequence = PublishSubject<Int>()
  _ = sequence.takeWhile { int in
    int > 3
    }.subscribe {
      print($0)
  }
  sequence.on(.Next(1))
  sequence.on(.Next(2))
  sequence.on(.Next(3))
  sequence.on(.Next(4))
  sequence.on(.Next(5))

}

func concat() {
  let variable1 = BehaviorSubject(value: 0)
  let variable2 = BehaviorSubject(value: 200)
  let variable3 = BehaviorSubject(value: variable1)
  
  _ = variable3.concat().subscribe {
    print($0)
  }
  
  variable1.on(.Next(1))
  variable1.on(.Next(2))
  
  variable3.on(.Next(variable2))
  variable2.on(.Next(201))
  variable1.on(.Next(5))
  variable1.on(.Next(6))
  variable1.on(.Completed)
  
  variable2.on(.Next(202))
}


func reduce() {
  _ = Observable.of(0,1,2,3,4,5,6,7,8,9)
    .reduce(0, accumulator: +).subscribe {
      print($0)
  }
  
  let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
  _ = int1.subscribe {
    print("first subscription \($0)")
  }
  delay(5) {
    _ = int1.subscribe {
      print("second subscription \($0)")
    }
  }
}


func multicast() {
  let subject1 = PublishSubject<Int64>()
  _ = subject1.subscribe {
    print("Subject \(0)")
  }
  
  let Int1 = Observable<Int64>.interval(1, scheduler: MainScheduler.instance).multicast(subject1)
  
  _ = Int1.subscribe {
    print("first subscription \($0)")
  }
  
  delay (2) {
    Int1.connect()
  }
  
  delay (5) {
    _ = Int1.subscribe {
      print("second subscription \($0)")
    }
  }
  
  delay (10) {
    _ = Int1.subscribe {
      print("Third subscription \($0)")
    }
  }
}

func replay1() {
  let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(0)
  _ = int1.subscribe {
    print("first subscription \($0)")
  }
  
  delay(2) {
    int1.connect()
  }
  
  delay(4, task: {
    _ = int1.subscribe( {
      print("second subscription \($0)")
    })
  })
}

func replay2() {
  let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    .replay(0)
  _ = int1
    .subscribe {
      print("first subscription \($0)")
  }
  
  delay(2) {
    int1.connect()
  }
  
  delay(4) {
    _ = int1
      .subscribe {
        print("second subscription \($0)")
    }
  }
  
  delay(6) {
    _ = int1.subscribe {
      print("third subscription \($0)")
    }
  }
}

func publish() {
  let int1 = Observable<Int>.interval(5, scheduler: MainScheduler.instance).publish()
  _ = int1.subscribe {
    print("first subscription \($0)")
  }
  
  delay(2) {
    int1.connect()
  }
  
  delay(4) {
    _ = int1.subscribe {
      print("second subscription \($0)")
    }
  }
  
  delay(6){
    _ = int1.subscribe {
      print("third subscription \($0)")
    }
  }
}
















