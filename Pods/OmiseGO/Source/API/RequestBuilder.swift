//
//  RequestBuilder.swift
//  OmiseGO
//
//  Created by Mederic Petit on 16/3/18.
//

import UIKit

final class RequestBuilder {
    private let configuration: ClientConfiguration
    private let authScheme = "OMGClient"

    init(configuration: ClientConfiguration) {
        self.configuration = configuration
    }

    func buildHTTPURLRequest(withEndpoint endpoint: APIEndpoint) throws -> URLRequest {
        guard let requestURL = URL(string: self.configuration.baseURL)?.appendingPathComponent(endpoint.path) else {
            throw OMGError.configuration(message: "Invalid base url")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0

        try addRequiredHeaders(toRequest: &request)

        // Add endpoint's task parameters if necessary
        if let parameters = endpoint.task.parameters {
            let payload = try parameters.encodedPayload()
            request.httpBody = payload
            request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
        }

        return request
    }

    func buildWebsocketRequest() throws -> URLRequest {
        guard let url = URL(string: self.configuration.baseURL) else {
            throw OMGError.configuration(message: "Invalid base url")
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 6.0
        try addRequiredHeaders(toRequest: &request)
        return request
    }

    func encodedAuthorizationHeader() throws -> String {
        guard let authenticationToken = self.configuration.authenticationToken else {
            throw OMGError.configuration(message: "Please provide an authentication token before using the SDK")
        }

        let keys = "\(self.configuration.apiKey):\(authenticationToken)"
        let data = keys.data(using: .utf8, allowLossyConversion: false)

        guard let encodedKey = data?.base64EncodedString() else {
            throw OMGError.configuration(message: "bad API key or authentication token (encoding failed.)")
        }

        return "\(self.authScheme) \(encodedKey)"
    }

    func contentTypeHeader() -> String {
        return "application/vnd.omisego.v\(self.configuration.apiVersion)+json; charset=utf-8"
    }

    func acceptHeader() -> String {
        return "application/vnd.omisego.v\(self.configuration.apiVersion)+json"
    }

    private func addRequiredHeaders(toRequest request: inout URLRequest) throws {
        let auth = try encodedAuthorizationHeader()
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(acceptHeader(), forHTTPHeaderField: "Accept")
        request.addValue(contentTypeHeader(), forHTTPHeaderField: "Content-Type")
    }
}
