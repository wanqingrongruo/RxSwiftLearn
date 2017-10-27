//
//  TransformingViewController.swift
//  RxDemo
//
//  Created by roni on 2017/10/26.
//  Copyright © 2017年 roni. All rights reserved.
//

import UIKit
import RxSwift
import Foundation

class TransformingViewController: UIViewController {
    
    var bag = DisposeBag()
    
    @IBOutlet weak var optionSeg: UISegmentedControl!
    
    @IBAction func optionChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            map()
        case 1:
            flatMap()
        case 2:
            scan()
        case 3:
            reduce()
        case 4:
            buffer()
        case 5:
            window()
        default:
            break
        }
    }
    
    @IBAction func combiningOptions(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            map()
        case 1:
            flatMap()
        case 2:
            scan()
        case 3:
            reduce()
        case 4:
            buffer()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /**
         * ## 过滤
         *  filter
         * distinctUntilChanged: 阻止发射与上一个重复的值
         * take: 只发射指定数量的值。 takelatest: 只发射序列结尾指定数量的值,使用 takeLast 时，序列一定是有序序列，takeLast 需要序列结束时才能知道最后几个是哪几个值。所以 takeLast 会等序列结束才向后发射值
         * skip: 忽略指定数量的值
         * debouce/throttle: 仅在过了一段指定的时间还没发射数据时才发射一个数据，换句话说就是 debounce 会抑制发射过快的值。注意这一操作需要指定一个线程(。有一个很常见的应用场景，比如点击一个 Button 会请求一下数据，然而总有刁民想去不停的点击，那这个 debounce 就很有用了)
         * elementAt: 使用 elementAt 就只会发射一个值了，也就是指发射序列指定位置的值
         * single: single 就类似于 take(1) 操作，不同的是 single 可以抛出两种异常： RxError.MoreThanOneElement 和 RxError.NoElements 。当序列发射多于一个值时，就会抛出 RxError.MoreThanOneElement ；当序列没有值发射就结束时， single 会抛出 RxError.NoElements
         * sample: 就是抽样操作，按照 sample 中传入的序列发射情况进行抽样
         ```
         Observable<Int>.interval(0.1, scheduler: SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
         .take(100)
         .sample(Observable<Int>.interval(1, scheduler: SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)))
         .subscribe {
         print($0)
         }
         .addDisposableTo(disposeBag)
         ```
         `在这个例子中我们使用 interval 创建了每 0.1s 递增的无限序列，同时用 take 只留下前 100 个值。抽样序列是一个每 1s 递增的无限序列。`
         */

        
        /**
         * ## 组合
         * startWith: 在一个序列前插入一个值
         * combineLatest: 当两个序列中的任何一个发射了数据时，combineLatest 会结合并整理每个序列发射的最近数据项
         * zip
         * merge
         * switchLatest
         */

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func map() { // 变换每一个值
        let originSeq = Observable.of(1, 2, 3)
        originSeq.map { (item) -> Int in
            return item*2
            }
            .subscribe { (event) in
                print(event)
            }.addDisposableTo(bag)
        //        originSeq.mapWithIndex { (item, index) -> Int in  // 第二个参数是 index
        //            return item * index
        //            }
        //            .subscribe { (event) in
        //                print(event)
        //            }
        //            .addDisposableTo(bag)
    }
    
    func flatMap() { // 把一个序列发射的值转换成一个序列
        
        let seqInt = Observable.of(1, 2, 3)
        let seqString = Observable.of("a", "b","c")
        
        seqInt.flatMap { (x) -> Observable<String> in
            print("from seqInt \(x)")
            return seqString
            }
            .subscribe { (event) in
                print(event)
            }.addDisposableTo(bag)
        
        //        seqInt.flatMapLatest { (x) -> Observable<String> in  // 保持最新的, 丢弃旧值 -- 网络请求; flatMapFirst 相反,保留旧值丢弃新值
        //            print("from seqInt \(x)")
        //            return seqString
        //            }
        //            .subscribe { (event) in
        //                print(event)
        //            }.addDisposableTo(bag)
        
    }
    
    func scan() {
        let sumSeq = Observable.of(1, 2, 3, 4, 5)
        sumSeq.scan(0) { (s, ele) in
            s + ele
            }
            .subscribe { (event) in
                print(event)
            }
            .addDisposableTo(bag)
    }
    
    func reduce() { // 最会发射最终值
        let sumSeq = Observable.of(1, 2, 3, 4, 5)
        sumSeq.scan(0) { (s, ele) in
            s + ele
            }
            .subscribe { (event) in
                print(event)
            }
            .addDisposableTo(bag)
    }
    
    func buffer() {
        let sumSeq = Observable.of(1, 2, 3, 4, 5, 6)
        sumSeq.buffer(timeSpan: 5, count: 2, scheduler: MainScheduler.instance)
            .subscribe{
                print($0)
            }
            .addDisposableTo(bag)
    }
    
    func window() {
        let sumSeq = Observable.of(1, 2, 3, 4, 5, 6)
        sumSeq.window(timeSpan: 5, count: 2, scheduler: MainScheduler.instance)
            .subscribe{
                print($0)
            }
            .addDisposableTo(bag)
    }
}

extension TransformingViewController {
    func startWith(){
        
    }
}
