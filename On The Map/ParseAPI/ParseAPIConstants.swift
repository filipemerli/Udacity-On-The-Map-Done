//
//  ParseAPIConstants.swift
//  On The Map
//
//  Created by Filipe Merli on 22/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation

extension ParseAPIClient {
    struct ParseConstants {
        static let limitNumber: Int = 100
        static let parseUrl = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let getMethodLimit = "?limit=\(limitNumber)"
        static let orderFromNewestToOldest = "&order=-updatedAt"
    }
}

