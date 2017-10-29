//
//  Constants.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

typealias HardJSON = [String : Any]
typealias JSON     = [String : Any]?
typealias ObjJSON  = [String : AnyObject]

typealias VoidBlock    = () -> ()
typealias StatusBlock  = (ActionStatus) -> ()
typealias StringsBlock = (ActionStatus, [String]?) -> ()
typealias JsonBlock    = (ActionStatus, JSON) -> ()
typealias ButtonBlock  = (UIButton) -> ()

extension Notification.Name {
    static let geocodeFinish  = Notification.Name("geocode_finish")
}


public enum ActionStatus {
    case success
    case noconnection
    case unrecognized
    case cancelled
    
    case httpfail
    case httpunknown
    case httpmsgerror
    case http404
    case http500
    case jsonreqerror
    case jsonreserror
    case nopost
    
    case missingfields
    case missingpassword
    
    case badaccount
    case badcredentials
    case badtoken
    case badauth
    case badpassword
    case badinitial
    case nouser
    case unauthorized
    
    case nomatchpassword
    case shortpassword
    case shortusername
    case unsupportedemail
    
}


public let ActionDescription: [ActionStatus : (String, String)] = [
    .success:         ("Success", "No need for a prompt."),
    .noconnection:    ("No Internet Connection", "The connection has failed. Please try again later."),
    .unrecognized:    ("Unexpected Error", "An unexpected error occured. Please try again later."),
    .cancelled:       ("Task cancelled", "The previous request has been replaced by a new one"),
    
    .httpfail:        ("HTTP Error", "The server returned an invalid status. Please try again."),
    .httpunknown:     ("HTTP Error", "The server returned with an unknown error. Please try again."),
    .httpmsgerror:    ("HTTP Error", "The server's response could not be understood. Please try again."),
    .http404:         ("HTTP 404", "The desired resource is not available. Please try again."),
    .http500:         ("HTTP 500", "The server returned an invalid status. Please try again."),
    .jsonreqerror:    ("Malformed Request", "Your request parameters are incorrect. Please try again."),
    .jsonreserror:    ("Malformed Response", "The response object could not be parsed. Please try again."),
    .nopost:          ("HTTP Error", "The server could not accept the previous request"),
    
    .missingfields:   ("Missing Fields", "Please fill in all required fields before submitting."),
    .missingpassword: ("Missing Password", "Please fill in your password before submitting."),
    
    .badaccount:      ("Unsupported Account", "The Condecca app currently does not support employer accounts."),
    .badcredentials:  ("Incorrect Credentials", "Your username and password are not recognized. Make sure they are correct and try again."),
    .badtoken:        ("Session Expired", "Your session has expired. Press OK to log in again."),
    .badauth:         ("Login Failed", "Your credentials could not be verified. Please try again later."),
    .badpassword:     ("Incorrect Password", "Your current password could not be recognized. Please correct it and try again."),
    .badinitial:        ("Initial Amount Error", "Please enter a non-negative amount to start off with"),
    .nouser:          ("User Not Loaded", "Some data has not yet loaded. Please try again."),
    .unauthorized:    ("Unauthorized", "Your request could not be authorized. Please try again."),
    
    .nomatchpassword:  ("Passwords do not Match","The passwords you entered do not match. Make sure they are correct and try again."),
    .shortusername:    ("Username Too Short", "Usernames must be at least 4 characters in length. Please enter a longer username and try again."),
    .shortpassword:    ("Password Too Short", "Passwords must be at least 8 characters in length. Please enter a longer password and try again."),
    
]


