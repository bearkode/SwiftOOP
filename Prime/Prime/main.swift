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

    let rowsPerPage: Int
    let columnCount: Int
    
    init(rowsPerPage: Int = 7, columnCount: Int = 5) {
        self.rowsPerPage = rowsPerPage
        self.columnCount = columnCount
    }
    
    func printNumbers(_ numbers: [Int]) {
        self.numbers = numbers
        self.pageNumber = 1
        self.pageOffset = 0
        
        while self.pageOffset < numbers.count {
            self.printPage()
            self.pageNumber = self.pageNumber + 1
            self.pageOffset = self.pageOffset + self.rowsPerPage * self.columnCount
        }
    }
    
    private var numbers: [Int] = []
    private var pageNumber: Int = 1
    private var pageOffset: Int = 0
    
    private func printPage() {
        self.printHeader()
        
        for rowOffset in self.pageOffset..<(self.pageOffset + self.rowsPerPage) {
            self.printRow(rowOffset: rowOffset)
        }
    }
    
    private func printHeader() {
        print("The First \(self.numbers.count) Prime Numbers --- page \(self.pageNumber)")
    }
    
    private func printRow(rowOffset: Int) {
        for column in 0..<self.columnCount {
            self.printColumn(column: column, rowOffset: rowOffset)
        }
        print("")
    }
    
    private func printColumn(column: Int, rowOffset: Int) {
        let index = rowOffset + column * self.rowsPerPage
        if index < self.numbers.count {
            let num = String(format: "%10d", self.numbers[index])
            print("\(num)", terminator: "")
        }
    }

}


class PrintPrimes {

    static func main() {
        let primes = PrimeFinder(max: 1000).find()
        assert(primes.last == 7919)
        assert(primes.count == 1000)
        NumberPrinter(rowsPerPage: 50, columnCount: 4).printNumbers(primes)
    }

}


PrintPrimes.main()
