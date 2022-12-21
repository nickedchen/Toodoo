//
//  DataStore.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-20.
//

import Foundation
import Combine

class DataStore: ObservableObject {
    // @Published var toDos:[ToDo] = []
    var toDos = CurrentValueSubject<[ToDo], Never>([])
    // @Published var appError: ErrorType? = nil
    var appError = CurrentValueSubject<ErrorType?, Never>(nil)
    var addToDo = PassthroughSubject<ToDo, Never>()
    var updateToDo = PassthroughSubject<ToDo, Never>()
    var deleteToDo = PassthroughSubject<IndexSet, Never>()
    var loadTodos = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(FileManager.docDirURL.path)
        addSubscriptions()
    }
    
    func addSubscriptions() {
        appError
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        loadTodos
            .filter{FileManager.default.fileExists(atPath: $0.path)}
            .tryMap{ url in
                try Data(contentsOf: url)
            }
            .decode(type: [ToDo].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.init(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self](completion) in
                switch completion {
                case .failure(let error):
                    if error is TooDooError{
                        self.appError.send(ErrorType(error: error as! TooDooError))
                    }else{
                        self.appError.send(ErrorType(error: TooDooError.decodingError))
                        toDosSubscription() 
                    }
                case .finished:
                    print("Loading completed")
                    toDosSubscription()
                }

            } receiveValue: { (toDos) in
                self.objectWillChange.send()

                self.toDos.value = toDos
            }
            .store(in: &subscriptions)

        addToDo
            .sink { [unowned self] toDo in
                toDos.value.append(toDo)
                 self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        updateToDo
            .sink { [unowned self] toDo in
                guard let index = toDos.value.firstIndex(where: { $0.id == toDo.id}) else { return }
                toDos.value[index] = toDo
                 self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        deleteToDo
            .sink { [unowned self] indexSet in
                toDos.value.remove(atOffsets: indexSet)
                 self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }

    func toDosSubscription(){
         toDos
            .subscribe(on: DispatchQueue.init(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap { data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink{ (completion) in
                switch completion {
                case .failure(let error):
                    if error is TooDooError{
                        self.appError.send(ErrorType(error: error as! TooDooError))
                    }else{
                        self.appError.send(ErrorType(error: TooDooError.encodingError))
                    }
                case .finished:
                    print("Saving completed")
                }
            } receiveValue: { _ in
                print("Saving was successful")
            }
            .store(in: &subscriptions)
    }
}
