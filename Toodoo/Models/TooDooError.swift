 //
//  TooDooError.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-20.
//

import Foundation

enum TooDooError: Error, LocalizedError{
    case saveError
    case readError
    case decodingError
    case encodingError

    var errorDescription: String?{
        switch self{
        case .saveError:
            return NSLocalizedString("Could not save Todos, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not save Todos, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("Therewas a problem loading your Todos, please create a new todo to restart.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save Todos, please reinstall the app.", comment: "")
        }
    }
}

struct ErrorType: Identifiable{
    var id = UUID()
    var error: TooDooError
}
