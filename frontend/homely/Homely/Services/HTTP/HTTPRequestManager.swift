//
//  HTTPRequestManager.swift
//  Homely
//
//  Created by Pedro Belfort on 12.10.24.
//

import Foundation

// Define an actor for managing ongoing requests
actor RequestManager<E: EndpointProtocol> {
    private var ongoingRequests: [E: Bool] = [:]
    
    // Safely check if a request is ongoing
    func isRequestOngoing(for endpoint: E) -> Bool {
        return ongoingRequests[endpoint] == true
    }
    
    // Safely set request as ongoing or completed
    func setRequestOngoing(_ ongoing: Bool, for endpoint: E) {
        ongoingRequests[endpoint] = ongoing
    }
}
