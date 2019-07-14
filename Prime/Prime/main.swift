//
//  main.swift
//  Prime
//
//  Created by bearkode on 14/07/2019.
//  Copyright © 2019 bearkode. All rights reserved.
//

import Foundation


class PrintPrimes {

    static func main() {
        let M = 1000
        let RR = 50
        let CC = 4
        let ORDMAX = 30
        var p: [Int] = Array<Int>(repeating: 0, count: M + 1)
        var pageNumber: Int = 0
        var pageOffset: Int = 0
        var j: Int = 0
        var k: Int = 0
        var jPrime: Bool = false
        var ord: Int = 0
        var square: Int = 0
        var n: Int = 0
        var mult: [Int] = Array<Int>(repeating: 0, count: ORDMAX + 1)

        j = 1
        k = 1
        p[1] = 2
        ord = 2
        square = 9

        while k < M {
            repeat {
                j = j + 2
                if j == square {
                    ord = ord + 1
                    square = p[ord] * p[ord]
                    mult[ord - 1] = j
                }
                n = 2
                jPrime = true
                while n < ord && jPrime {
                    while mult[n] < j {
                        mult[n] = mult[n] + p[n] + p[n]
                    }
                    if mult[n] == j {
                        jPrime = false
                    }
                    n = n + 1
                }
            } while !jPrime
            k = k + 1
            p[k] = j
        }

        pageNumber = 1
        pageOffset = 1
        while pageOffset <= M {
            print("The First \(M) Prime Numbers --- page \(pageNumber)")
            for rowOffset in pageOffset..<(pageOffset + RR) {
                for c in 0..<CC {
                    if rowOffset + c * RR <= M {
                        let num = String(format: "%10d", p[rowOffset + c * RR])
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


PrintPrimes.main()


