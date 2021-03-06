//
//  KeychainManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 6/2/21.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

protocol KeychainManagerProtocol {
    func storeItem(code: String) throws
    func searchItem() throws -> String
    func deleteItem() throws
}

class KeychainManager: KeychainManagerProtocol {
    let server = "reinaldovillajavi.SpotiSearch"

    func storeItem(code: String) throws {
        let password = code.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecSuccess else { return } //If not correct we try to update

        try self.updateItem(code: code)
    }

    private func updateItem(code: String) throws {
        let password = code.data(using: String.Encoding.utf8)!
        let updateQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                          kSecAttrServer as String: server]
        let attributes: [String: Any] = [kSecValueData as String: password]
        let status = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    func searchItem() throws -> String {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
            throw KeychainError.unexpectedPasswordData
        }
        return password
    }

    func deleteItem() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
