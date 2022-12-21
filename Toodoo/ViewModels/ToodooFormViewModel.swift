//
//  ToodooFormViewModel.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-20.
//

import Foundation

class ToodooFormViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var completed: Bool = false
    var id: String?

    var updating: Bool{
        id != nil
    }

    var isDisabled: Bool{
        name.isEmpty
    }

    init(){}

    init(_ currentToDo: ToDo){
       self.name = currentToDo.name
        self.completed = currentToDo.completed
        id = currentToDo.id
    }
}
