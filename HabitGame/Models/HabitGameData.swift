//
//  HabitGameData.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import Foundation

enum Category: String, CaseIterable {
    case all = "All"
    case perso = "Perso"
    case pro = "Pro"
    case vacation = "Vacation"
}

struct ExpensesData {
    var name: String = ""
    var value: Double = 0.00
    var Category: Category

    static var expensesTest = [
        ExpensesData(name:"Apple", value:120.00, Category: .perso),
        ExpensesData(name:"Airbnb", value:1200.00, Category: .perso),
        ExpensesData(name:"McDonald", value:300.00, Category: .vacation),
        ExpensesData(name:"Bakery", value:10.00, Category: .perso),
        ExpensesData(name:"Mechanic", value:1000.00, Category: .pro)
    ]
}
