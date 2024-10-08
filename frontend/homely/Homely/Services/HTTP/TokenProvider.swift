//
//  TokenProvider.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

protocol TokenProviderProtocol {
    var jwtToken: String? { get }
    func setToken(_ token: String) throws
    func clearToken()
    func refreshToken() async throws -> String
    var hasAccessToken: Bool { get }
}
