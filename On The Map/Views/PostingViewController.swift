//
//  PostingViewController.swift
//  On The Map
//
//  Created by Filipe Merli on 30/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController {

    @IBOutlet weak var addLocationTextField: UITextField!
    @IBOutlet weak var addLinkTextField: UITextField!
    
    @IBAction func findLocationButton(_ sender: Any) {
        if (addLinkTextField.text?.isEmpty)! {
            sendUIAlert(error: "Please, insert a valid link!\n (like: https://udacity.com)")
        }
        else if (addLocationTextField.text?.isEmpty)! {
            sendUIAlert(error: "Please, insert a valid location!\n (like: Boston, MA)")
        }else {
            Student.shared.url = addLinkTextField.text!
            let address = addLocationTextField.text!
            performUIUpdatesOnMain {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.getUserLocation(address: address) { (result, error) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    guard error ==  nil else {
                        self.sendUIAlert(error: error as? String)
                        return
                    }
                    if result == true {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewPinView")
                        self.present(controller!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func postPinCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addLinkTextField.delegate = self
        self.addLocationTextField.delegate = self
        let spinner = PostingViewController.displaySpinner(onView: self.view)
        performUIUpdatesOnMain {
            ParseAPIClient.sharedInstance().taskForGetSingleMethod { results, error in
                if let resultArray = results!["results"] as? [AnyObject] {
                    if resultArray.count >= 1 {
                        Student.shared.firstTimePosting = false
                        self.sendUIMessage(message: "Overwrinting your current location!")
                    } else {
                       Student.shared.firstTimePosting = true
                        self.sendUIMessage(message: "You are new here xD")
                    }
                } else {
                    Student.shared.firstTimePosting = true
                    self.sendUIMessage(message: "You are new here :D")
                }
                PostingViewController.removeSpinner(spinner: spinner)
            }
        }
    }
}

// MARK: TextFields Delegate

extension PostingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "" && textField == addLinkTextField)  {
            textField.text = "https://"
        }
        
    }
}


