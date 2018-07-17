//
//  TransactionConsumption.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// The status of a transaction consumption
///
/// - pending: The transaction consumption is pending validation
/// - confirmed: The transaction was consumed
/// - failed: The transaction failed to be consumed
public enum TransactionConsumptionStatus: String, Decodable {
    case pending
    case confirmed
    case approved
    case rejected
    case failed
    case expired
}

/// Represents a transaction consumption
public struct TransactionConsumption {
    /// The unique identifier of the consumption
    public let id: String
    /// The status of the consumption (pending, confirmed or failed)
    public let status: TransactionConsumptionStatus
    /// The amount of token to transfer (down to subunit to unit)
    public let amount: BigInt?
    /// The estimated amount in the request currency
    public let estimatedRequestAmount: BigInt
    /// The estimated amount in the consumption currency
    public let estimatedConsumptionAmount: BigInt
    /// The final amount to be transfered after exchange in the request currency
    public let finalizedRequestAmount: BigInt?
    /// The final amount to be transfered after exchange in the consumption currency
    public let finalizedConsumptionAmount: BigInt?
    /// The token for the request
    /// In the case of a type "send", this will be the token that the consumer will receive
    /// In the case of a type "receive" this will be the token that the consumer will send
    public let token: Token
    /// An id that can uniquely identify a transaction. Typically an order id from a provider.
    public let correlationId: String?
    /// The idempotency token of the consumption
    public let idempotencyToken: String
    /// The transaction generated by this consumption (this will be nil until the consumption is confirmed)
    public let transaction: Transaction?
    /// The address used for the consumption
    public let address: String
    /// The user that initiated the consumption
    public let user: User?
    /// The account that initiated the consumption
    public let account: Account?
    /// The transaction request to be consumed
    public let transactionRequest: TransactionRequest
    /// The topic which can be listened in order to receive events regarding this consumption
    public let socketTopic: String
    /// The creation date of the consumption
    public let createdAt: Date
    /// The date when the consumption will expire
    public let expirationDate: Date?
    /// The date when the consumption got approved
    public let approvedAt: Date?
    /// The date when the consumption got rejected
    public let rejectedAt: Date?
    /// The date when the consumption got confirmed
    public let confirmedAt: Date?
    /// The date when the consumption failed
    public let failedAt: Date?
    /// The date when the consumption expired
    public let expiredAt: Date?
    /// Additional metadata for the consumption
    public let metadata: [String: Any]
    /// Additional encrypted metadata for the consumption
    public let encryptedMetadata: [String: Any]
}

extension TransactionConsumption: Listenable {}

extension TransactionConsumption: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case amount
        case estimatedRequestAmount = "estimated_request_amount"
        case estimatedConsumptionAmount = "estimated_consumption_amount"
        case finalizedRequestAmount = "finalized_request_amount"
        case finalizedConsumptionAmount = "finalized_consumption_amount"
        case token
        case correlationId = "correlation_id"
        case idempotencyToken = "idempotency_token"
        case user
        case account
        case transactionRequest = "transaction_request"
        case transaction
        case address
        case socketTopic = "socket_topic"
        case expirationDate = "expiration_date"
        case createdAt = "created_at"
        case approvedAt = "approved_at"
        case rejectedAt = "rejected_at"
        case confirmedAt = "confirmed_at"
        case failedAt = "failed_at"
        case expiredAt = "expired_at"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(TransactionConsumptionStatus.self, forKey: .status)
        amount = try container.decodeIfPresent(BigInt.self, forKey: .amount)
        estimatedRequestAmount = try container.decode(BigInt.self, forKey: .estimatedRequestAmount)
        estimatedConsumptionAmount = try container.decode(BigInt.self, forKey: .estimatedConsumptionAmount)
        finalizedRequestAmount = try container.decodeIfPresent(BigInt.self, forKey: .finalizedRequestAmount)
        finalizedConsumptionAmount = try container.decodeIfPresent(BigInt.self, forKey: .finalizedConsumptionAmount)
        token = try container.decode(Token.self, forKey: .token)
        correlationId = try container.decodeIfPresent(String.self, forKey: .correlationId)
        idempotencyToken = try container.decode(String.self, forKey: .idempotencyToken)
        transaction = try container.decodeIfPresent(Transaction.self, forKey: .transaction)
        user = try container.decodeIfPresent(User.self, forKey: .user)
        account = try container.decodeIfPresent(Account.self, forKey: .account)
        transactionRequest = try container.decode(TransactionRequest.self, forKey: .transactionRequest)
        address = try container.decode(String.self, forKey: .address)
        socketTopic = try container.decode(String.self, forKey: .socketTopic)
        expirationDate = try container.decodeIfPresent(Date.self, forKey: .expirationDate)
        approvedAt = try container.decodeIfPresent(Date.self, forKey: .approvedAt)
        rejectedAt = try container.decodeIfPresent(Date.self, forKey: .rejectedAt)
        confirmedAt = try container.decodeIfPresent(Date.self, forKey: .confirmedAt)
        failedAt = try container.decodeIfPresent(Date.self, forKey: .failedAt)
        expiredAt = try container.decodeIfPresent(Date.self, forKey: .expiredAt)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
    }
}

extension TransactionConsumption: Retrievable {
    @discardableResult
    /// Consume a transaction request from the given TransactionConsumptionParams object
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The TransactionConsumptionParams object describing the transaction request to be consumed.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func consumeTransactionRequest(using client: HTTPClient,
                                                 params: TransactionConsumptionParams,
                                                 callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        return self.retrieve(using: client,
                             endpoint: .transactionRequestConsume(params: params),
                             callback: callback)
    }

    @discardableResult
    /// Approve the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func approve(using client: HTTPClient,
                        callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionConfirmationParams(id: id)
        return self.retrieve(using: client, endpoint: .transactionConsumptionApprove(params: params), callback: callback)
    }

    @discardableResult
    /// Reject the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func reject(using client: HTTPClient,
                       callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionConfirmationParams(id: id)
        return self.retrieve(using: client, endpoint: .transactionConsumptionReject(params: params), callback: callback)
    }
}

extension TransactionConsumption: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: TransactionConsumption, rhs: TransactionConsumption) -> Bool {
        return lhs.id == rhs.id
    }
}