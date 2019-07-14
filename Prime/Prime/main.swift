//
//  main.swift
//  Prime
//
//  Created by bearkode on 14/07/2019.
//  Copyright © 2019 bearkode. All rights reserved.
//

import Foundation


class PrimeFinder {

    static func find() -> [Int] {
        let max = 1000
        let ORDMAX = 30
        var primes: [Int] = Array<Int>(repeating: 0, count: max + 1)
        var candidate: Int = 0
        var numberOfPrimes: Int = 0
        var isPrime: Bool = false
        var ord: Int = 0
        var square: Int = 0
        var n: Int = 0
        var mult: [Int] = Array<Int>(repeating: 0, count: ORDMAX + 1)

        candidate = 1
        numberOfPrimes = 1
        primes[1] = 2
        ord = 2
        square = 9

        while numberOfPrimes < max {
            repeat {
                candidate = candidate + 2
                if candidate == square {
                    ord = ord + 1
                    square = primes[ord] * primes[ord]
                    mult[ord - 1] = candidate
                }
                n = 2
                isPrime = true
                while n < ord && isPrime {
                    while mult[n] < candidate {
                        mult[n] = mult[n] + primes[n] + primes[n]
                    }
                    if mult[n] == candidate {
                        isPrime = false
                    }
                    n = n + 1
                }
            } while !isPrime
            numberOfPrimes = numberOfPrimes + 1
            primes[numberOfPrimes] = candidate
        }

        return primes
    }

}


class NumberPrinter {

    static func printNumber(_ numbers: [Int]) {
        let RR = 50
        let CC = 4
        var pageNumber: Int = 0
        var pageOffset: Int = 0

        pageNumber = 1
        pageOffset = 1
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
        let primes = PrimeFinder.find()
        NumberPrinter.printNumber(primes)
    }

}


PrintPrimes.main()
