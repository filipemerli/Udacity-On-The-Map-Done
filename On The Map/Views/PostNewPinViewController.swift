//
//  PostNewPinViewController.swift
//  On The Map
//
//  Created by Filipe Merli on 05/02/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit
import MapKit

class PostNewPinViewController: UINavigationController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapNewPin: MKMapView!
    

    @IBAction func finishPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //mapNewPin.delegate = self
 
    }




}
