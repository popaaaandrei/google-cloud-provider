//
//  ObjectACLAPI.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 5/20/18.
//

import Vapor

public protocol ObjectAccessControlsAPI {
    func delete(bucket: String, entity: String, object: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse>
    func get(bucket: String, entity: String, object: String, queryParameters: [String: String]?) throws -> Future<ObjectAccessControls>
    func create(bucket: String, object: String, entity: String, role: String, queryParameters: [String: String]?) throws -> Future<ObjectAccessControls>
    func list(bucket: String, object: String, queryParameters: [String: String]?) throws -> Future<ObjectAccessControlsList>
    func patch(bucket: String, object: String, entity: String, queryParameters: [String: String]?) throws -> Future<ObjectAccessControls>
    func update(bucket: String, object: String, entity: String, defaultAccessControl: ObjectAccessControls?, queryParameters: [String: String]?) throws -> Future<ObjectAccessControls>
}

public class GoogleObjectAccessControlsAPI: ObjectAccessControlsAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    /// Permanently deletes the ACL entry for the specified entity on the specified object.
    public func delete(bucket: String, entity: String, object: String, queryParameters: [String: String]? = nil) throws -> Future<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/o/\(object)/acl/\(entity)", query: queryParams, body: "")
    }
    
    /// Returns the ACL entry for the specified entity on the specified object.
    public func get(bucket: String, entity: String, object: String, queryParameters: [String: String]? = nil) throws -> Future<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/o/\(object)acl/\(entity)", query: queryParams, body: "")
    }
    
    /// Creates a new ACL entry on the specified object.
    public func create(bucket: String, object: String, entity: String, role: String, queryParameters: [String: String]? = nil) throws -> Future<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let body = try JSONEncoder().encode(["entity": entity, "role": role]).convert(to: String.self)
        
        return try request.send(method: .POST, path: "\(endpoint)/\(bucket)/o/\(object)/acl", query: queryParams, body: body)
    }
    
    /// Retrieves ACL entries on the specified object.
    public func list(bucket: String, object: String, queryParameters: [String: String]? = nil) throws -> Future<ObjectAccessControlsList> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/o/\(object)/acl", query: queryParams, body: "")
    }
    
    /// Updates an ACL entry on the specified object. This method supports patch semantics.
    public func patch(bucket: String, object: String, entity: String, queryParameters: [String: String]? = nil) throws -> Future<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/o/\(object)/acl/\(entity)", query: queryParams, body: "")
    }
    
    /// Updates an ACL entry on the specified object.
    public func update(bucket: String,
                       object: String,
                       entity: String,
                       defaultAccessControl: ObjectAccessControls? = nil,
                       queryParameters: [String: String]? = nil) throws -> Future<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        var body = ""
        
        if let defaultAccessControl = defaultAccessControl {
            body = try JSONSerialization.data(withJSONObject: try defaultAccessControl.toEncodedDictionary()).convert(to: String.self)
        }
        
        return try request.send(method: .POST, path: "\(endpoint)/\(bucket)/o/\(object)/acl/\(entity)", query: queryParams, body: body)
    }
}