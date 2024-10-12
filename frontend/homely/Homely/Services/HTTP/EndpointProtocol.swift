//
//  EndpointProtocol.swift
//  Homely
//
//  Created by Pedro Belfort on 12.10.24.
//

import Foundation

protocol EndpointProtocol: Equatable, Hashable, Sendable {
    var path: String { get }
    func url(for environment: EnvConfig) -> String
}
