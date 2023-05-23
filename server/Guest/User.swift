//
//  User.swift
//  Guest
//
//  Created by Yasyf Mohamedali on 5/22/23.
//

import Foundation



class User {
    let id: UUID
    private var _code: String? = nil
    
    init(id: UUID) {
        self.id = id
    }
    
    var code: Data {
        if _code == nil {
            self._code = fetchCode()
        }
        return _code!.data(using: .utf8)!
    }
    
    private func fetchCode() -> String {
        // get name from clerk, and create code
        return "1234"
    }
}
