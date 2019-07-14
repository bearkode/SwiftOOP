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

    func find() -> [Int] {
        self.prepare()
        self.checkOddNumbers()

        return self.primes
    }

    func prepare() {
        self.primes = [2]
        self.checker = PrimeChecker(source: self)
    }

    func checkOddNumbers() {
        var candidate: Int = 3

        while self.primes.count < self.max {
            if self.checker.isPrime(candidate) {
                self.primes.append(candidate)
            }
            candidate = candidate + 2
        }
    }

    func primeNumber(at index: Int) -> Int {
        return self.primes[index]
    }

    let max: Int
    var primes: [Int] = []
    var checker = PrimeChecker(source: nil)

}


protocol PrimeSource: AnyObject {

    func primeNumber(at index: Int) -> Int
    var primes: [Int] { get }

}


class PrimeChecker {

    init(source: PrimeSource?) {
        self.source = source
        self.multiples = [2]
    }

    weak var source: PrimeSource?
    
    var multiples: [Int]

    func isPrime(_ candidate: Int) -> Bool {
        if  self.isLeastRelevantMultipleOfNextLargerPrimeFactor(candidate: candidate)  {
            self.multiples.append(candidate)
            return false
        }
        
        for n in (0..<self.multiples.count) {
            if self.isMultipleOfPrimeFactor(candidate: candidate, nth: n) {
                return false
            }
        }
        
        return true
    }
    
    func isLeastRelevantMultipleOfNextLargerPrimeFactor(candidate: Int) -> Bool {
        let nextLargerPrimeFactor = self.nextLargerPrimeFactor
        let leastRelevantMultiple = nextLargerPrimeFactor * nextLargerPrimeFactor
        return candidate == leastRelevantMultiple
    }
    
    var nextLargerPrimeFactor: Int {
        guard let source = self.source, source.primes.count > self.multiples.count else {
            return 0
        }
        
        return self.source!.primeNumber(at: self.multiples.count)
    }

    func isMultipleOfPrimeFactor(candidate: Int, nth: Int) -> Bool {
        return candidate == self.smallestOddMultiple(notLessThan: candidate, nth: nth)
    }

    func smallestOddMultiple(notLessThan candidate: Int, nth n: Int) -> Int {
        guard let source = self.source else {
            assert(false)
        }

        var multiple = self.multiples[n]
        let primeAtNo = source.primeNumber(at: n)

        while multiple < candidate {
            multiple += (primeAtNo * 2)
            self.multiples[n] = multiple
        }

        return multiple
    }

}


class NumberPrinter {

    static func printNumber(_ numbers: [Int]) {
        let RR = 50
        let CC = 4
        var pageNumber = 1
        var pageOffset = 0

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
        assert(primes.count == 1000)
        NumberPrinter.printNumber(primes)
    }

}


PrintPrimes.main()
