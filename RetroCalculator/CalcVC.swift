//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Alexander Shenshin on 20.05.17.
//  Copyright © 2017 Alexander Shenshin. All rights reserved.
//

import UIKit
import AVFoundation

class CalcVC: UIViewController {
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Devide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    var currentOperation = Operation.Empty
    var runningNumber = "0a"
    
    

    @IBOutlet weak var outputLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
       outputLbl.text = "0.0"
    }
    
    @IBAction func numberPressed(sender: UIButton){
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(_ sender: UIButton) {
        processOperation(operation: Operation.Devide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: UIButton) {
        processOperation(operation: Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: UIButton) {
        processOperation(operation: Operation.Subtract)
    }
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        processOperation(operation: Operation.Add)
    }
    
    @IBAction func onEqualPressed(_ sender: UIButton) {
        processOperation(operation: currentOperation)
    }
    
    func playSound(){
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }

    @IBAction func onClearPressed(_ sender: UIButton) {
        playSound()
        outputLbl.text = "0.0"
        leftValStr = ""
        rightValStr = ""
        result = ""
        currentOperation = Operation.Empty
        runningNumber = "0"
    }
    
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            //Пользователь выбрал оператор, а потом поменял его на другой, не вводя операнд
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                switch currentOperation {
                case Operation.Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case Operation.Devide:
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                case Operation.Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                case Operation.Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                default:
                    result = "pizdetz"
                }
                leftValStr = result
                outputLbl.text = result
                
            }
            
            currentOperation = operation
        } else {
            //это первый раз, когда оператор был выбран
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    
    }

}

