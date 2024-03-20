//
//  ViewController.swift
//  HWlesson28
//
//  Created by Карина Дьячина on 17.03.24.
//

import UIKit

protocol BancAccount {
    var balance: Decimal { get set }
    
    func deposit(_ value: Decimal)
    func withdraw(_ value: Decimal)
}

class ViewController: UIViewController, BancAccount {
    var balance: Decimal = 0.0
    
    let lock = NSLock()
    let recursiveLock = NSRecursiveLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deposit(10.00)
        work()
        withdraw(1.00)
        doAnotherFunction()
        doDeposit()
        
    }

    func deposit(_ value: Decimal) {
        if value > 0 {
            balance += value
            print("Balance: \(balance)")
        }
    }
    
    func withdraw(_ value: Decimal) {
        if balance > value {
            balance -= value
            print("Balance: \(balance)")
        } else {
            print("You have not enough money for this transaction")
        }
    }
    
    func work() {
    lock.lock()
        DispatchQueue.main.async { [self] in
            deposit(20.00)
        }
    lock.unlock()
    }
    
    func doAnotherFunction() {
        recursiveLock.lock()
        DispatchQueue.main.async { [self] in
            doDeposit()
        }
        withdraw(10.00)
        recursiveLock.unlock()
    }

    func doDeposit() {
        recursiveLock.lock()
        DispatchQueue.main.async { [self] in
            deposit(80.00)
        }
        recursiveLock.unlock()
    }

   
}

