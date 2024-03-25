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

class BankService: BancAccount {
    
    var balance: Decimal = 0.0
    let lock = NSLock()
    let recursiveLock = NSRecursiveLock()
    
    func deposit(_ value: Decimal) {
        lock.lock()
        if value > 0 {
            balance += value
            print("Balance: \(balance)")
        }
        lock.unlock()
    }
    
    func withdraw(_ value: Decimal) {
        recursiveLock.lock()
        if balance > value {
            balance -= value
            print("Balance: \(balance)")
        } else {
            print("You have not enough money for this transaction")
        }
        recursiveLock.unlock()
    }
}

class ViewController: UIViewController {
    
    var bankService: BancAccount = BankService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankService.deposit(10.00)
        work()
        bankService.withdraw(1.00)
        doAnotherFunction()
        doDeposit()
    }
    
    
    func work() {
        DispatchQueue.global().async { [self] in
            bankService.deposit(20.00)
        }
    }
    
    func doAnotherFunction() {
        DispatchQueue.main.async { [self] in
            doDeposit()
        }
        bankService.withdraw(10.00)
    }
    
    func doDeposit() {
        DispatchQueue.main.async { [self] in
            bankService.deposit(80.00)
        }
    }
}

