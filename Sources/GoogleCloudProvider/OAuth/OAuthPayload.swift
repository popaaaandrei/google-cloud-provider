//
//  OAuthPayload.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/15/18.
//

import Vapor
import JWT

public struct OAuthPayload: JWTPayload {
    var iss: IssuerClaim
    var scope: String
    var aud: AudienceClaim
    var iat: IssuedAtClaim
    var exp: ExpirationClaim
    
    public func verify() throws {
        try exp.verify()
    }
}