//
//  TableViewController.swift
//  CIC
//
//  Created by Данила on 28.05.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

//convenience init(time: Int, frequency: Int, capital: Double, initialCapital: Double, percent: Double, currency: String?, lotPrice: Double) {
//    self.init()
//
//    self.time = Int64(time)
//    self.frequency = Int64(frequency)
//    self.capital = capital
//    self.initialCapital = initialCapital
//    self.percent = percent
//    self.currency = currency
//    self.lotPrice = lotPrice
//}

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var calculations = [Calculation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCalculations()
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calculations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
        
        let profit = ((calculations[indexPath.row].capital - calculations[indexPath.row].initialCapital)*100).rounded(.down)/100

        let nc = (calculations[indexPath.row].capital*100).rounded(.down)/100
        cell.newCapital.text = "\(nc) " + calculations[indexPath.row].currency!
        
        cell.oldCapital.text = "\(calculations[indexPath.row].initialCapital) " + calculations[indexPath.row].currency!
        cell.paysByYear.text = "\(calculations[indexPath.row].frequency) PBY"
        cell.profitLabel.text = "+\(profit)" + calculations[indexPath.row].currency!
        cell.percentLabel.text = "\(calculations[indexPath.row].percent) %"
        cell.timeLabel.text = "\(calculations[indexPath.row].time) Y`"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Добавление жеста удаления строки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard  editingStyle == .delete else { return }

        let calc = calculations[indexPath.row]
        calculations.remove(at: indexPath.row)
        context.delete(calc)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getCalculations () {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        let fetchRequest:NSFetchRequest<Calculation> = Calculation.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "percent", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            calculations = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }

}

