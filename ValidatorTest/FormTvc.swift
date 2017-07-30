//
//  FormTvc.swift
//  ValidatorTest
//
//  Created by Saleh Masum on 7/27/17.
//  Copyright © 2017 Selise. All rights reserved.
//

import UIKit
import SwiftValidator

class FormTvc: UITableViewController, ValidationDelegate {
  
  //TextFields
  @IBOutlet weak var phoneTextField:        UITextField!
  @IBOutlet weak var emailTextField:        UITextField!
  @IBOutlet weak var zipCodeTextField:      UITextField!
  @IBOutlet weak var lastNameTextField:     UITextField!
  @IBOutlet weak var firstNameTextField:    UITextField!
  @IBOutlet weak var emailConfirmTextField: UITextField!

  //Error Labels
  @IBOutlet weak var emailErrorLabel:         UILabel!
  @IBOutlet weak var phoneErrorLabel:         UILabel!
  @IBOutlet weak var zipCodeErrorLabel:       UILabel!
  @IBOutlet weak var lastNameErrorLabel:      UILabel!
  @IBOutlet weak var firstNameErrorLabel:     UILabel!
  @IBOutlet weak var emailConfirmErrorLabel:  UILabel!

  let validator = Validator()

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    emailConfirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    zipCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
    registerIntendedTextFields()
    
  }
  
  func textFieldDidChange(_ textField: UITextField) {
    
    //
    validator.validateField(textField){ error in
      if error == nil {
        // Field validation was successful
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 0.5
      } else {
        // Validation error occurred
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
      }
    }
    //
    
  }
  
  func registerIntendedTextFields() {
    
    validator.styleTransformers(success:{ (validationRule) -> Void in
      print("here")
      // clear error label
      validationRule.errorLabel?.isHidden = true
      validationRule.errorLabel?.text = ""
      if let textField = validationRule.field as? UITextField {
        textField.layer.borderColor = UIColor.white.cgColor
       textField.layer.borderWidth = 0.5
        
      }
    }, error:{ (validationError) -> Void in
      print("error")
      validationError.errorLabel?.isHidden = false
      validationError.errorLabel?.text = validationError.errorMessage
      if let textField = validationError.field as? UITextField {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
      }
    })
    
    //Validation rules evaluated from left to right
    validator.registerField( firstNameTextField,     errorLabel: firstNameErrorLabel,    rules: [ RequiredRule(),   MinLengthRule(length:2)])
    validator.registerField( lastNameTextField,      errorLabel: lastNameErrorLabel,     rules: [ RequiredRule(),   MinLengthRule(length: 2) ])
    validator.registerField( emailTextField,         errorLabel: emailErrorLabel,        rules: [ RequiredRule(),   EmailRule(message: "Invalid Email") ])
    validator.registerField( phoneTextField,         errorLabel: phoneErrorLabel,        rules: [ RequiredRule(),   MinLengthRule(length: 9) ])
    validator.registerField( zipCodeTextField,       errorLabel: zipCodeErrorLabel,      rules: [ RequiredRule(),   ZipCodeRule(regex: "\\d{5}")])
    validator.registerField( emailConfirmTextField,  errorLabel: emailConfirmErrorLabel, rules: [ ConfirmationRule(confirmField: emailTextField) ])
  }
  
  func validationFailed( _ errors:[ (Validatable, ValidationError) ]) {
    for ( field, error ) in errors {
      if let field = field as? UITextField {
        field.layer.borderColor     = UIColor.red.cgColor
        field.layer.borderWidth     = 1.0
      }
      error.errorLabel?.text          = error.errorMessage
      error.errorLabel?.isHidden      = false
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  @IBAction func submitButtonAction(_ sender: UIButton) {
    
    validator.validate(self)
    
  }

  // MARK: ValidationDelegate Methods
  
  func validationSuccessful() {
    print("Validation Success!")
    let alert = UIAlertController(title: "Success", message: "You are validated!", preferredStyle: UIAlertControllerStyle.alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(defaultAction)
    self.present(alert, animated: true, completion: nil)
    
  }
  
  
}
