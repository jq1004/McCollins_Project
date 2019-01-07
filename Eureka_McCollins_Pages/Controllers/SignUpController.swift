//
//  ViewController.swift
//  Eureka_McCollins_Pages
//
//  Created by Junqing li on 1/6/19.
//  Copyright © 2019 Junqing li. All rights reserved.
//

import UIKit
import Eureka
import DLRadioButton

class SignUpController: FormViewController {
    var fname: String?
    var lname: String?
    var email: String?
    var mobile: String?
    var password: String?
    var cpassword: String?
    var dob: String?
    var gender: String?
    @IBOutlet weak var femaleBtn: DLRadioButton!
    @IBOutlet weak var maleBtn: DLRadioButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignUp()
    }
    
    
    @IBAction func signUpBtn(_ sender: UIButton) {
//        tableView.reloadData()
        if femaleBtn.isSelected {
            gender = "Female"
        } else {
            gender = "Male"
        }
        print(fname)
        print(lname)
        print(email)
        print(mobile)
        print(password)
        print(cpassword)
        print(dob)
        print(gender)
        let formFilled: Bool = fname != nil && fname != ""&&lname != nil && lname != "" && email != nil && email != "" && mobile != nil && mobile != "" && password != nil && password != "" && cpassword != nil && cpassword != "" && dob != nil && dob != "" && password == cpassword && gender != nil && gender != ""
        if formFilled == true {
            signUpAPI(fname: fname!, lname: lname!, email: email!, mobile: mobile!, password: password!, cpassword: cpassword!, dob: dob!, gender: gender!)
        }
        else{
            let signFailedAlert = UIAlertController(title: "SignUp Failed", message: "Please register again!", preferredStyle: .alert)
            signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(signFailedAlert, animated: true, completion: nil)
            print("sign up failed!")
        }
    }
    func signUpAPI(fname:String,lname:String,email:String,mobile:String,password:String,cpassword:String,dob:String,gender:String) {
        let Url = String(format: "http://mccollinsmedia.com/myproject/service/registerUser")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["fname":fname,"lname":lname,"email": email, "mobile":mobile ,"password" : password, "cpassword":cpassword,"dob":dob,"gender":gender]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        else {
                            return
                    }
                    let iserror = json["iserror"] as! String
                    if iserror == "Yes" {
                        DispatchQueue.main.async {
                            let signFailedAlert = UIAlertController(title: "SignUp Failed", message: "Please register again!", preferredStyle: .alert)
                            signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(signFailedAlert, animated: true, completion: nil)
                        }
                    }
                    else {
                        print("is erros is No")
                    }
                    self.navigationController?.popViewController(animated: true)
                }catch {
                    DispatchQueue.main.async {
                        let signFailedAlert = UIAlertController(title: "SignUp Failed", message: "Please register again!", preferredStyle: .alert)
                        signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(signFailedAlert, animated: true, completion: nil)
                    }
                    print(error)
                }
            }
            }.resume()
    }
    
    func setupSignUp(){
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        form
            +++ Section()
            <<< TextFloatLabelRow() {
                $0.title = "First Name"
                $0.cell.height = { 48 }
                }.cellUpdate({ (cell, row) in
                     self.fname = cell.textField.text
                })
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
                }
            
            <<< TextFloatLabelRow() {
                $0.title = "Last Name"
                $0.cell.height = { 48 }
                }.cellUpdate({ (cell, row) in
                    self.lname = cell.textField.text
                })
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            
            <<< EmailFloatLabelRow() {
                $0.title = "Email Id"
                $0.cell.height = { 48 }
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    } else{
                        self.email = cell.textField.text
                    }
                })
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            
            <<< TextFloatLabelRow() {
                $0.title = "Phone No"
                $0.cell.height = { 48 }
                }.cellUpdate({ (cell, row) in
                    self.mobile = cell.textField?.text
                   
                })
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
       
            <<< TextFloatLabelRow() {
                $0.title = "Password"
                $0.tag = "password"
                $0.cell.height = { 48 }
                $0.add(rule: RuleMinLength(minLength: 6))
                }.cellUpdate({ (cell, row) in
                    if !row.isValid{
                        cell.textField.textColor = .red
                    }
                    else{
                        self.password = cell.textField.text
    
                      }
                })
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            
            <<< TextFloatLabelRow() {
                $0.title = "Confirm Password"
                $0.cell.height = { 48 }
                $0.add(rule: RuleEqualsToRow(form: form, tag: "password"))
                }.cellUpdate({ (cell, row) in
                    if !row.isValid{
                        cell.textField?.textColor = .red
                       
                    } else{
                         self.cpassword = cell.textField?.text
                    }
                })
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            
            <<< TextFloatLabelRow() {
                $0.title = "DOB"
                $0.cell.height = { 48 }
                }.cellUpdate({ (cell, row) in
                    self.dob = cell.textField?.text
                })
    }

}

