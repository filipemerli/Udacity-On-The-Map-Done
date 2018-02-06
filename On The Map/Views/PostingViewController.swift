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
        } else {
            Student.shared.url = addLinkTextField.text!
            performUIUpdatesOnMain {
                self.getUserLocation { placemark in
                    Student.shared.city = (placemark?.locality)!
                    Student.shared.state = (placemark?.administrativeArea)!
                    self.addLocationTextField.text = "\(Student.shared.state), "+"\(Student.shared.city)"
                    self.addLinkTextField.text = Student.shared.url
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewPinView")
                    self.present(controller!, animated: true, completion: nil)
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
       /* performUIUpdatesOnMain {
            ParseAPIClient.sharedInstance().taskForGetSingleMethod { result, error in
                if error == nil {
                    //print(result)
                } else {
                    self.sendUIAlert(error: "Not able to get you location info from Udacity")
                }
            }
        }*/
        
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
        textField.text = "https://"
    }
}


