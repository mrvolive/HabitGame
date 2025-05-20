//
//  DailyPoint.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

struct DailyPoints: Identifiable, Hashable {
    var id = UUID()
    var day: String // Ex: "Lun", "Mar"
    var points: Int
    var date: Date = Date() // Pour un tri ou une logique plus avancée
}
