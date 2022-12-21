//
//  TooDooFormView.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-20.
//

import SwiftUI

struct TooDooFormView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var formVM: ToodooFormViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            Form{
                TextField("ToDo", text: $formVM.name)
                Toggle("Completed", isOn: $formVM.completed)
            }
            .navigationTitle("Edit Todo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: updateSaveButton
            )
        }
    }
}

extension TooDooFormView{
    func updateToDo() {
        let toDo = ToDo(id: formVM.id!, name: formVM.name, completed: formVM.completed)
        dataStore.updateToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addToDo() {
        let toDo = ToDo(name: formVM.name)
        dataStore.addToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button( formVM.updating ? "Update" : "Save",
                action: formVM.updating ? updateToDo : addToDo)
            .disabled(formVM.isDisabled)
    }
}

struct TodoFormView_Previews: PreviewProvider {
    static var previews: some View {
        TooDooFormView(formVM:ToodooFormViewModel())
            .environmentObject(DataStore())
    }
}
