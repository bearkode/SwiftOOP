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

    let max: Int

    func find() -> [Int] {
        self.prepare()

        var candidate: Int = 1

        while self.primes.count <= self.max {
            candidate = candidate + 2
            if self.isPrime(candidate) {
                self.primes.append(candidate)
            }
        }

        return self.primes
    }

    func prepare() {
        self.primes = []
        self.mult = Array<Int>(repeating: 0, count: ORDMAX + 1)

        self.primes.append(0)
        self.primes.append(2)
        self.ord = 2
        self.square = 9
    }

    var ord: Int = 0
    var square: Int = 0
    let ORDMAX = 30
    var primes: [Int] = []
    var mult: [Int] = []

    func isPrime(_ candidate: Int) -> Bool {
        if candidate == self.square {
            self.ord = self.ord + 1
            self.square = self.primes[ord] * self.primes[ord]
            self.mult[ord - 1] = candidate
        }

        var n = 2
        var isPrime = true
        while n < self.ord && isPrime {
            while self.mult[n] < candidate {
                self.mult[n] = self.mult[n] + self.primes[n] + self.primes[n]
            }

            if self.mult[n] == candidate {
                isPrime = false
            }
            n = n + 1
        }

        return isPrime
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
        NumberPrinter.printNumber(primes)
    }

}


PrintPrimes.main()
