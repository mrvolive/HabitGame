//
//  ContentView.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack() {
                VStack {
                    ForEach(ExpensesData.expensesTest, id:\.self){expense in
                        Text("test")
                    }
                }
                .navigationTitle("Expenses")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Button{
                            
                        } label: {
                            Text("Edit")
                        }
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            
                        } label: {
                            Text("Add")
                        }
                    }
                }
            }
            .tabItem {
                Text("Expenses")
                Image(systemName: "dollarsign.square")
                    .renderingMode(.template)
            }
            .tag(0)
            
            NavigationStack() {
                Text("Overview")
                    .navigationTitle("Overview")
                
            }
            .tabItem {
                Text("Overview")
                Image(systemName: "chart.bar")
                
            }
            .badge("12")
            .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
