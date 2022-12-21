//
//  ModelType.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-20.
//

import SwiftUI

enum ModelType: Identifiable,View{
    case new
    case update(ToDo)
    var id: String{
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }

    var body: some View{
        switch self {
        case .new:
            return TooDooFormView(formVM: ToodooFormViewModel())
        case .update(let toDo):
            return TooDooFormView(formVM: ToodooFormViewModel(toDo))
        }
    }
}
