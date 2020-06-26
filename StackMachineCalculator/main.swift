//
//  main.swift
//  StackMachineCalculator
//
//  Created by Владислав on 25.03.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

private class Node<T>{
    let value: T
    weak var previous: Node<T>?
    var next: Node<T>?
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T>{
    private var head: Node<T>?
    private var tail: Node<T>?
    
    func isEmpty() -> Bool{
        return head == nil
    }
    fileprivate func headNode()->Node<T>?{
        return head
    }
    fileprivate func tailNode()->Node<T>?{
        return tail
    }
    
    func append(_ listElement: T) -> (){
        
        let newNode = Node(value: listElement)
        
        if let lastNode = tail{
            lastNode.next = newNode
            newNode.previous = lastNode
        } else {
            head = newNode
        }
        tail = newNode
    }
    
    func deleteLast() -> T?{
        var lastNodeValue: T?
        if let lastElement = tail{
            lastNodeValue = lastElement.value
            tail = lastElement.previous
            lastElement.previous?.next = nil
        }
        return lastNodeValue
    }
}

extension LinkedList: CustomStringConvertible{
    //used to print all LinkedList node's values
    var description: String {
        var printText = "["
        var node = head
        
        while node?.next != nil {
            printText += node!.value as! String
            node = node?.next!
            if node != nil{
                printText += ", "
            }
        }
        printText += (node?.value)! as! String
        return printText + "]"
    }
}


func matches(for regex: String, in text: String) -> [String]{
    //Return array of divided symbols without any spaces between them
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
        
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func calculate(for stringExpression: String?) -> String{
    
    enum Operstions: String{
        case addition = "+"
        case subsraction = "-"
        case division = "/"
        case multiplication = "*"
    }
    
    let numbersFromText = LinkedList<String>()
    if let expression = stringExpression{
        let regex = try! NSRegularExpression(pattern: "[^0-9]")
        for number in matches(for: "[0-9]*[+-/*]*[^ \t\n\r]", in: expression){
            if (regex.firstMatch(in: number, range: NSRange(number.startIndex..., in: number)) != nil){
                
                guard let firstStringeNumber = numbersFromText.deleteLast() else {return "The expression has been uncorrected entered. Check it out"}
                guard let secondStringNumber = numbersFromText.deleteLast() else {return "The expression has been uncorrected entered. Check it out"}
                guard let firstOperand = Int(firstStringeNumber) else {return "The expression has been uncorrected entered. Check it out"}
                guard let secondOperand = Int(secondStringNumber) else {return "The expression has been uncorrected entered. Check it out"}
                
                switch number {
                case Operstions.addition.rawValue:
                    let result = firstOperand + secondOperand
                    numbersFromText.append(String(result))
                    print(numbersFromText)
                case Operstions.subsraction.rawValue:
                    let result = firstOperand - secondOperand
                    numbersFromText.append(String(result))
                    print(numbersFromText)
                case Operstions.multiplication.rawValue:
                    let result = firstOperand * secondOperand
                    numbersFromText.append(String(result))
                    print(numbersFromText)
                case Operstions.division.rawValue:
                    guard firstOperand != 0 && secondOperand != 0 else {return "Expression with null can't be diveded"}
                    let result = firstOperand / secondOperand
                    numbersFromText.append(String(result))
                    print(numbersFromText)
                default:
                    return ("Enexpected operation; Avaliable operations: + - * /")
                }

            } else {
                numbersFromText.append(number)
            }
        }
    }
    if let a = numbersFromText.tailNode()?.value{
        return a
    } else {
        return "Nothing in LinnkedList"
    }
}

print("Please, enter your expression with spaces between every operands")
let someExpression = readLine()

print(calculate(for: someExpression))

