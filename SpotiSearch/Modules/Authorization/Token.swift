//
//  Token.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import Foundation

struct Token: Equatable {
    let accessToken: String
    let expiresIn: Date

    init(accessToken: String, expiresIn: Date) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
    }

    init(tokenDTO: TokenDTO) {
        self.init(accessToken: tokenDTO.accessToken,
                  expiresIn: Date(timeIntervalSinceNow: tokenDTO.expiresIn))
    }
}
