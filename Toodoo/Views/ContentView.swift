//
//  ContentView.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-19.
//

import SwiftUI

struct Item {
    let uuid = UUID()
    let value: String
}

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var modelType: ModelType? = nil
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                List {
                    ForEach(dataStore.toDos.value) { toDo in
                        Button(action: {
                            modelType = .update(toDo)
                        }, label: {
                            HStack {
                                Text(toDo.name)
                                    .foregroundColor(toDo.completed ? .gray : .primary)
                                    .strikethrough(toDo.completed)
                            }
                        })
                    }
                    .onDelete(perform: dataStore.deleteToDo.send)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Toodoos")
            }
            .sheet(item: $modelType) { $0 }
            .alert(item: $dataStore.appError.value) { appError in
                Alert(title: Text("Oh Oh"), message: Text(appError.error.localizedDescription))
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        modelType = .new
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.white)
                            .padding(20)
                    })
                    .background(Color.blue)
                    .cornerRadius(1000)
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStore())
    }
}
