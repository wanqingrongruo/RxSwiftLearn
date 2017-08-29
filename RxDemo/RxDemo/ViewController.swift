//
//  ViewController.swift
//  RxDemo
//
//  Created by roni on 2017/8/28.
//  Copyright © 2017年 roni. All rights reserved.
//

import UIKit
import RxSwift
import Foundation

enum CustomError: Error {
    case somethingWrong
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObservable()
    }

   
    
    func createObservable() {
        /*
        // Obeservable: 以时间为索引的常量队列
        let numberObservale = Observable.of("1", "2", "3", "4", "5", "6", "7", "8", "9").map{ Int($0) }.filter{
            if let item = $0, item % 2 == 0 {
                print("Even: \(item)")
                return  true
            }
            return false
        }
      //  另一种使用方式
      //  _ = Observable.from(["1", "2", "3", "4", "5", "6", "7", "8", "9"])
        
        
        // It's similar to sequence how to use 'Map' and 'Filter'
        // In sequence, is sync
        // But here, is async, It only presents that we would deal with this sequence, but not now.
        // 验证: 调用这个方法并不会打印出结果
        
        // 当有人订阅了它, 才会开始执行
        _ = numberObservale.subscribe { (event) in
            print("Event: \(event)")
        }
        
        print("===================================")
        
        // 半路订阅者
        _ = numberObservale.skip(2).subscribe({ (event) in
            print("Event2: \(event)")
        })
        
        // operator 对 Observable 的加工是在订阅的时候发生的
        // 这种只有在订阅的时候才 emit(发行,发表) 事件的 Observable，有一个专有的名字，叫做 Cold Observable。
        
        // Observer 通过 subscribe 和 observable 产生联系...所以 subscrbe 也是一个 operator
        /**
         * ## Observer 和 Observale 之间的约定
         * 1. 当 Observable 正常发送事件时,会调用 Observer 提供的 OnNext 方法, 这个过程习惯上叫做 emissions
         * 2. 当 Observable 成功结束时, 会调用 Observer 提供的 onCompleted 方法, 因此,在最后一次调用 onNext 之后, 就会调用 onCompleted.
         * 3. 当 Observable 发生错误时, 就会调用 Observer 提供的 onError方法, 并且, 一旦发生错误,就不会再继续发送其他事件了.对于调用 onCompleted 和 onNext 的过程,习惯上叫做 notifications.
         */
        */
        print("===================================")
        
        // onDisposed: Observable 使用的资源被回收的时候, 会调用 Observer 提供的 onDisposed 方法(dispose: 处置,惰性)
        
//        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe(onNext: { (index) in
//            print("Subscribed: \(index)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil)
//        dispatchMain()
        
        // 把所有的订阅对象放在一个DisposeBag里，当DisposeBag对象被销毁的时候，它里面“装”的所有订阅对象就会自动取消订阅，对应的事件序列的资源也就被自动回收了
        var bag = DisposeBag()
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe(onNext: { (index) in
            print("Subscibe: \(index)")
        }, onError: nil, onCompleted: nil) { 
            print("The queue was disposed")
        }.disposed(by: bag)
        
        delay(5) { 
            bag = DisposeBag()
        }

    }
    
    
    func delay(_ delay: Double, action: @escaping () -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { 
            action()
        }
    }
    
    func customObservable() {
        
        let bag = DisposeBag()
        let customOb = Observable<Int>.create { (observer) -> Disposable in
            // 这里的 observer 并不是真正的订阅者, 而是一个转达者, 当有人订阅了当前 Observable 中的事件时,他会向订阅者传达不同情况的事件
            // 不同情况下的事件
            observer.onNext(10)
            observer.onError(CustomError.somethingWrong)
            observer.onNext(11)
            observer.onCompleted()
            
            return Disposables.create()
        }
        customOb.subscribe(onNext: { print($0) },
                           onError: { print($0) },
                           onCompleted: { print("Completed") },
                           onDisposed: { print("Game over") }
        ).addDisposableTo(bag)
        
        
    }

}


extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let n = Int(string) {
            
            if n % 2 == 0 {
                print("Even: \(n)")
            }
        }
        
        return true
    }
}
