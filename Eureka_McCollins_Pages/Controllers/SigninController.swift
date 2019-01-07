//
//  SigninController.swift
//  Eureka_McCollins_Pages
//
//  Created by Junqing li on 1/6/19.
//  Copyright © 2019 Junqing li. All rights reserved.
//

import UIKit
import Eureka

class SigninController: FormViewController {
    var emailTxt: String?
    var pwdTxt: String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        signUpAPI()
        setupSignin()
//        signInAPI(email: "jason20191004@gmail.com", pass: "asd") { (userModel) in
//            print(userModel.email)
//        }
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        print("signin button click")
        print(emailTxt)
        print(pwdTxt)
        let formFilled: Bool = emailTxt != nil && emailTxt != ""&&pwdTxt != nil && pwdTxt != ""
        if formFilled == true {
            signInAPI(email: emailTxt!, pass: pwdTxt!) { (userModel) in
                        print(userModel.email)
                    }
        }
        else{
            let signFailedAlert = UIAlertController(title: "Sign In Failed", message: "Please Sign In again!", preferredStyle: .alert)
            signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(signFailedAlert, animated: true, completion: nil)
            print("sign in failed!")
        }
    }
    
    func signInAPI(email : String, pass : String, completionHandler : @escaping (UserModel)->Void) {
        let Url = String(format: "http://mccollinsmedia.com/myproject/service/checklogin")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["email" : email, "password" : pass]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let data = data {
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            else {
                                return
                        }
                        let iserror = json["iserror"] as! String
                        if iserror == "No" {
                            let user = DataParsing.parseLoginUserInfo(json: json)
                            completionHandler(user)
                        } else {
                            print("json error!")
                            let error = json["message"] as! String
                            DispatchQueue.main.async {
                                let signFailedAlert = UIAlertController(title: "SignIn Failed", message: error, preferredStyle: .alert)
                                signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(signFailedAlert, animated: true, completion: nil)
                            }
                        }
                    }catch {
                        print("JSON PARSE ERROR!")
                        DispatchQueue.main.async {
                            let signFailedAlert = UIAlertController(title: "SignIn Failed", message: "please sign in again", preferredStyle: .alert)
                            signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(signFailedAlert, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                print("URL Session ERROR!")
                DispatchQueue.main.async {
                    let signFailedAlert = UIAlertController(title: "SignIn Failed", message: error!.localizedDescription, preferredStyle: .alert)
                    signFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(signFailedAlert, animated: true, completion: nil)
                }
            }
            
            }.resume()
    }
   

    func setupSignin(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        form
            +++ Section()
            
            <<< EmailFloatLabelRow() {
                $0.title = "Email Id"
                $0.cell.height = { 48 }
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.floatLabelTextField.titleTextColour = UIColor.red
                    } else {
                        self.emailTxt = cell.floatLabelTextField.text
                    }
            }
            
            <<< SpaceCellRow() {
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            
            <<< TextFloatLabelRow() {
                $0.title = "Password"
                $0.add(rule: RuleMinLength(minLength: 6))
                $0.cell.height = { 48 }
                }.cellUpdate({ (cell, row) in
                    print(cell.textField.text)
                    if !row.isValid{
                       cell.textField?.textColor = .red
                    }else{
                        self.pwdTxt = cell.textField.text
                    }
                    self.pwdTxt = cell.textField.text
                })
    }
}
