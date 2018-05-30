

//  SignUpViewController.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/26/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

protocol signUpRequest: NSObjectProtocol {
    func signUpdidSucceed()
}

class SignUpViewController: UIViewController,UITextFieldDelegate {
    var selectedCoup: Offer?
    weak var delegate: signUpRequest?

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passField: UITextField!

    @IBAction func signUp(_ sender: Any) {
        let wrongEmail: Bool = wrongEmailInputFormat()
        if wrongEmail {
            emailError.isHidden = false
        } else if shortPassword() {
            displayPasswordError()
        } else {
         UserDefaultsManager.instance.saveObject(true as AnyObject, key: Constants.UserDefaults.registeredKey)
            MenuTableViewControl.instance.tableView.reloadData()
            navigationController?.popViewController(animated: true)
            delegate?.signUpdidSucceed()
        }
    }

    // MARK: - validate Input
    func displayPasswordError() {
        emailError.text = NSLocalizedString("error pass", tableName: "LocalizeFile", bundle: Bundle.main, value: "error pass", comment: "")
        emailError.isHidden = false
    }

    func wrongEmailInputFormat() -> Bool {
        let emailReg = Constants.EmailRegExp
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email.text) == false
    }

    func shortPassword() -> Bool {
        return (passField.text?.count ?? 0) < 6
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - cancel registration
    @IBAction func cancel(_ sender: Any) {
        for controller: UIViewController? in navigationController?.viewControllers ?? [UIViewController?]() {
            if (controller is HomeViewController) {
                if let aController = controller {
                    navigationController?.popToViewController(aController, animated: true)
                }
                break
            }
        }
    }

// MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        email.keyboardType = .emailAddress
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nTag: Int = textField.tag
        if nTag == 1 {
            passField.becomeFirstResponder()
            return false
        } else {
            passField.resignFirstResponder()
            return true
        }
    }
}
