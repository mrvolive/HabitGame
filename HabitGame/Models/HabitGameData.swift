//
//  HabitGameData.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import Foundation

struct HabitsData: Identifiable{
    var id = UUID()
    var name: String
    var value: Int
    
    static var habitsTest = [
        HabitsData(name: "Méditer 10 minutes", value: 120),
        HabitsData(name: "Faire du sport", value: 200),
        HabitsData(name: "Lire 30 minutes", value: 150),
        HabitsData(name: "Boire 2L d'eau", value: 100),
        HabitsData(name: "Manger 5 fruits et légumes", value: 180)
    ]
    
    static func == (lhs: HabitsData, rhs: HabitsData) -> Bool {
        lhs.id == rhs.id
    }
}
