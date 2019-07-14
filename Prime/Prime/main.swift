//
//  main.swift
//  Prime
//
//  Created by bearkode on 14/07/2019.
//  Copyright © 2019 bearkode. All rights reserved.
//

import Foundation


class PrimeFinder {

    init(max: Int) {
        self.max = max
    }

    func find() -> [Int] {
        self.prepare()
        self.checkOddNumbers()

        return self.primes
    }
    
    // MARK: - private

    private let max: Int
    private var primes: [Int] = []
    private var multiples: [Int] = []

    private func prepare() {
        self.primes = [2]
        self.multiples = [2]
    }
    
    private func checkOddNumbers() {
        var candidate = 3
        
        while self.primes.count < self.max {
            if self.isPrime(candidate) {
                self.primes.append(candidate)
            }
            candidate += 2
        }
    }

    private func isPrime(_ candidate: Int) -> Bool {
        if self.isLeastRelevantMultipleOfNextLargerPrimeFactor(candidate: candidate) {
            self.multiples.append(candidate)
            return false
        }

        return self.isNotMultipleOfAnyPreviousPrimeFactors(candidate: candidate)
    }
    
    private func isNotMultipleOfAnyPreviousPrimeFactors(candidate: Int) -> Bool {
        for n in (0..<self.multiples.count) {
            if self.isMultipleOfPrimeFactor(candidate: candidate, nth: n) {
                return false
            }
        }
        
        return true
    }

    private func isLeastRelevantMultipleOfNextLargerPrimeFactor(candidate: Int) -> Bool {
        let nextLargerPrimeFactor = self.nextLargerPrimeFactor
        let leastRelevantMultiple = nextLargerPrimeFactor * nextLargerPrimeFactor
        return candidate == leastRelevantMultiple
    }
    
    private var nextLargerPrimeFactor: Int {
        guard self.primes.count > self.multiples.count else {
            return 0
        }
        
        return self.primes[self.multiples.count]
    }
    
    private func isMultipleOfPrimeFactor(candidate: Int, nth: Int) -> Bool {
        return candidate == self.smallestOddMultiple(notLessThan: candidate, nth: nth)
    }
    
    private func smallestOddMultiple(notLessThan candidate: Int, nth n: Int) -> Int {
        var multiple = self.multiples[n]
        
        while multiple < candidate {
            multiple += (self.primes[n] * 2)
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
