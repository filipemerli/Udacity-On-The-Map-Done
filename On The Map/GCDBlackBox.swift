//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Filipe Merli on 15/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
