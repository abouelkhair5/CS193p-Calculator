//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Amr Abou Elkhair on 2017-10-08.
//  Copyright © 2017 Amr Abouelkhair. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "%": Operation.unaryOperation({ $0/100 }),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "ln": Operation.unaryOperation(log),
        "log": Operation.unaryOperation(log10),
        "x²": Operation.unaryOperation({ pow($0,2) }),
        "x³": Operation.unaryOperation({ pow($0,3) }),
        "x!": Operation.unaryOperation({
            var result = 1
            for n in 1...Int($0){
                result *= n
            }
            return Double(result)
        }),
        "±": Operation.unaryOperation({ -$0 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals,
        ]
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var accumulator: Double?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var resultIsPending: Bool{
        get{
            return pendingBinaryOperation != nil
        }
    }
    
    var description = ""
    
    var result: Double! {
        get{
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                description = "\(description) \(symbol)"
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    description = "\(symbol)(\(description))"
                }
            case .binaryOperation(let function):
                performPendingBinaryOperation()
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    description = "\(description) \(symbol)"
                }
                accumulator = nil
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if pendingBinaryOperation == nil{
            description = String(operand)
            
        }
        else {
            description = "\(description) \(operand)"
        }
        accumulator = operand
    }
    
    mutating func reset(){
        accumulator = nil
        description = ""
        pendingBinaryOperation = nil
        
    }
}
