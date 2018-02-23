//
//  GlobalViewControllerExtension.swift
//  On The Map
//
//  Created by Filipe Merli on 29/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activIndic = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activIndic.startAnimating()
        activIndic.center = spinnerView.center
        performUIUpdatesOnMain {
            spinnerView.addSubview(activIndic)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        performUIUpdatesOnMain {
            spinner.removeFromSuperview()
        }
    }
    
    func sendUIMessage(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendUIAlert(error: String?) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToUrl(link: String?) {
        let application = UIApplication.shared
        if (link == "" || link == nil) {
            sendUIAlert(error: "Link field in blank!")
        } else {
            let url = URL(string: link!)
            if application.canOpenURL(url!) {
                application.open(url!, options: [:], completionHandler: nil)
            } else {
                sendUIAlert(error: "Not a valid link!")
            }
        }
        
    }
    
    func logoutConfirm() {
        let alertController = UIAlertController (title: nil, message: "Are you sure to Logout?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "OK", style: .default) {(action: UIAlertAction!) in
            UdacityAPIClient.sharedInstance().taskForDeleteMethod(completionHandlerForDelete: { (result, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.sendUIAlert(error: error?.domain ?? "Error on Logout request!\nTry again.")
                    }
                }
            })
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
}


