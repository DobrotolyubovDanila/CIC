//
//  ViewController.swift
//  CIC
//
//  Created by Данила on 21.05.2020.
//  Copyright © 2020 Данила. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var capitalField: UITextField!
    @IBOutlet weak var priceOfLotField: UITextField!
    @IBOutlet weak var timeLineTextField: UITextField!
    @IBOutlet weak var ferquency: UITextField!
    @IBOutlet weak var percentField: UITextField!
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var changed:Bool = false
    
    @IBOutlet weak var newCapitalLabel:UILabel!
    @IBOutlet weak var coefficientLabel:UILabel!
    @IBOutlet weak var profitLabel:UILabel!
    
    var newCapital:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPickerView.delegate = self
        
        scrollView.keyboardDismissMode = .onDrag
        
        calculateButton.layer.cornerRadius = 5
        
        saveButton.layer.cornerRadius = 5
        saveButton.isHidden = true
        
        newCapitalLabel.isHidden = true
        coefficientLabel.isHidden = true
        profitLabel.isHidden = true
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//            print(self.currency.selectedRow(inComponent: 0))
//        }
    
    }
    
    
    @IBAction func calculationButtonPressed() {
        
        // Извлекаем значения входных параметров
        guard
            var capital = getDouble(capitalField),
            let initialCapital = getDouble(capitalField),
            let lotPrice = getDouble(priceOfLotField),
            var time = Int(timeLineTextField.text!),
            var fre = Int(ferquency.text!),
            let percent = getDouble(percentField) else {
                
                saveButton.isHidden = true
                
                let alert = UIAlertController(title: "Некорректные данные", message: "Укажите все переменные", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
                return
        }
        
        // Корректируем данные
        if fre < 1 { fre = 1 }
        if time < 1 { time = 1 }
        
        let currency:String // Объявляем валюту
        // Определяем валюту
        switch currencyPickerView.selectedRow(inComponent: 0) {
        case 1:
            currency = "$"
            break
        case 2:
            currency = "€"
            break
        default:
            currency = "₽"
            break
        }
        // Вычисление новых значений
        if lotPrice == 0 {  //На случай депозита
            
            for _ in 1...time*fre {
                
                capital += capital*(percent/100)/Double(fre)
                
            }
            
            output(capital: capital, copyCapital: initialCapital, currency: currency)
            
            newCapital = capital
            
        } else { // Случай вложений в ценные бумаги
            
            for _ in 1...fre*time {
                
                let count = (capital/lotPrice).rounded(.down)
                
                capital += count*lotPrice*percent/100
                
            }

            output(capital: capital, copyCapital: initialCapital, currency: currency)
            // Сохранение
            newCapital = capital
        }
        
    }
    
    @IBAction func saveButtonPressed() {
        // Извлекаем значения входных параметров
        let capital = newCapital
        guard
            let initialCapital = getDouble(capitalField),
            let lotPrice = getDouble(priceOfLotField),
            var time = Int(timeLineTextField.text!),
            var fre = Int(ferquency.text!),
            let percent = getDouble(percentField) else {
                
                saveButton.isHidden = true
                
                let alert = UIAlertController(title: "Некорректные данные", message: "Укажите все переменные", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
                return
        }
        
        // Корректируем данные
        if fre < 1 { fre = 1 }
        if time < 1 { time = 1 }
        
        let currency:String // Объявляем валюту
        // Определяем валюту
        switch currencyPickerView.selectedRow(inComponent: 0) {
        case 1:
            currency = "$"
            break
        case 2:
            currency = "€"
            break
        default:
            currency = "₽"
            break
        }
        
        saveCalculation(time: time, frequency: fre, capital: capital, initialCapital: initialCapital, percent: percent, currency: currency, lotPrice: lotPrice)
        
    }
    
    func getDouble(_ field: UITextField) -> Double? {
    
        guard var text = field.text else { return Double(1)}
        
        guard let index = text.firstIndex(of: ",") else { return Double(text)}
        
        text.remove(at: index)
        text.insert(".", at: index)
        
        guard let doub = Double(text) else {return nil}
        
        return doub
    }
    
    func output (capital:Double, copyCapital: Double, currency: String) {
        newCapitalLabel.text = String((capital*100).rounded()/100) + " \(currency)"
        newCapitalLabel.isHidden = false
        
        let coefficient = (capital*100/copyCapital).rounded()/100
        coefficientLabel.text = "\(coefficient)"
        coefficientLabel.isHidden = false
        
        let profit = ((capital - copyCapital)*100).rounded()/100
        profitLabel.text = "\(profit) \(currency)"
        profitLabel.isHidden = false
        
        saveButton.isHidden = false
    }
    
    
    
    func saveCalculation (time: Int, frequency: Int, capital: Double, initialCapital: Double, percent: Double, currency: String?, lotPrice: Double) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Calculation", in: context) else { return }
        
        let calc = Calculation(entity: entity, insertInto: context)
        
        calc.capital = capital
        calc.currency = currency
        calc.frequency = Int16(frequency)
        calc.initialCapital = initialCapital
        calc.time = Int16(time)
        calc.percent = percent
        
        do {
            try context!.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showSaved" {
//            let dvc = segue.destination as! TableViewController
//
//        }
//    }
    
}




extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch row {
        case 0:
            return "₽"
        case 1:
            return "$"
        case 2:
            return "€"
        default:
            return nil
        }
    }
    
}

