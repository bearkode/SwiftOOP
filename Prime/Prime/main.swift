//
//  main.swift
//  Prime
//
//  Created by bearkode on 14/07/2019.
//  Copyright © 2019 bearkode. All rights reserved.
//

import Foundation


class PrimeFinder: PrimeSource {

    init(max: Int) {
        self.max = max
    }

    let max: Int
    var primes: [Int] = []
    var checker = PrimeChecker(source: nil)

    func find() -> [Int] {
        self.prepare()
        self.checkOddNumbers()

        return self.primes
    }

    func prepare() {
        self.primes = [0, 2]
        self.checker = PrimeChecker(source: self)
    }

    func checkOddNumbers() {
        var candidate: Int = 3

        while self.primes.count <= self.max {
            if self.checker.isPrime(candidate) {
                self.primes.append(candidate)
            }
            candidate = candidate + 2
        }
    }

    func primeNumber(at index: Int) -> Int {
        return self.primes[index]
    }

}


protocol PrimeSource: AnyObject {

    func primeNumber(at index: Int) -> Int

}

class PrimeChecker {

    init(source: PrimeSource?) {
        self.source = source
        self.mult = Array<Int>(repeating: 0, count: self.ORDMAX + 1)
        self.ord = 2
        self.square = 9
    }

    weak var source: PrimeSource?
    var ord: Int = 0
    var square: Int = 0
    let ORDMAX = 30
    var mult: [Int] = []

    func isPrime(_ candidate: Int) -> Bool {
        guard let source = self.source else {
            return false
        }

        if candidate == self.square {
            self.ord = self.ord + 1
            self.square = source.primeNumber(at: ord) * source.primeNumber(at: ord)
            self.mult[ord - 1] = candidate
        }

        var n = 2
        while n < self.ord {
            if self.isMultipleOfPrimeFactor(candidate: candidate, nth: n) {
                return false
            }
            n = n + 1
        }

        return true
    }

    func isMultipleOfPrimeFactor(candidate: Int, nth: Int) -> Bool {
        return candidate == self.smallestOddMultiple(notLessThan: candidate, nth: nth)
    }

    func smallestOddMultiple(notLessThan candidate: Int, nth n: Int) -> Int {
        guard let source = self.source else {
            assert(false)
        }

        var multiple = self.mult[n]
        let primeAtNo = source.primeNumber(at: n)

        while multiple < candidate {
            multiple += (primeAtNo * 2)
            self.mult[n] = multiple
        }

        return multiple
    }

}


class NumberPrinter {

    static func printNumber(_ numbers: [Int]) {
        let RR = 50
        let CC = 4
        var pageNumber = 1
        var pageOffset = 1

        while pageOffset < numbers.count {
            print("The First \(numbers.count - 1) Prime Numbers --- page \(pageNumber)")
            for rowOffset in pageOffset..<(pageOffset + RR) {
                for c in 0..<CC {
                    if rowOffset + c * RR < numbers.count {
                        let num = String(format: "%10d", numbers[rowOffset + c * RR])
                        print("\(num)", terminator: "")
                    }
                }
                print("")
            }
            pageNumber = pageNumber + 1
            pageOffset = pageOffset + RR * CC
        }
    }

}


class PrintPrimes {

    static func main() {
        let primes = PrimeFinder(max: 1000).find()
        assert(primes.last == 7919)
        assert(primes.count == 1001)
        NumberPrinter.printNumber(primes)
    }

}


PrintPrimes.main()
