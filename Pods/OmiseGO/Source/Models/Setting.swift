//
//  Setting.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents the global settings of the provider
public struct Setting: Decodable {
    /// An array of tokens available for the provider
    public let tokens: [Token]
}

extension Setting: Retrievable {
    @discardableResult
    /// Get the global settings of the provider
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: HTTPClient,
                           callback: @escaping Setting.RetrieveRequestCallback) -> Setting.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: .getSettings, callback: callback)
    }
}
