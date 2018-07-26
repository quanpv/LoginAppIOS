//
//  LoginViewController.swift
//  LoginApp
//
//  Created by Quan Pham Van on 7/18/18.
//  Copyright © 2018 QuanPV. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import Alamofire

class LoginViewController: BaseViewController {

    @IBOutlet var passwordTF: OMGFloatingTextField!
    @IBOutlet var emailTF: OMGFloatingTextField!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        let text: String = (emailTF?.text?.description)!
        print("login btn clicked:\(text)")
        emailTF?.text = "quanpv.hut@gmail.com"
//        requestHttp("https://api.github.com/users/quanpv")
        getInformationGitHub("https://api.github.com/users/quanpv") {
            response in print(response.avatarUrl?.absoluteString.description ?? "")
        }
    }
    
    
    func getInformationGitHub(_ url:String,  completionClosure: @escaping ObjectClosure<MyGithub>) {
        APIController.requestHttp(url,  completionClosure: completionClosure)
    }
    
    func requestHttp(_ url:String) {
        Alamofire.request(url).responseData() {
            data in
            switch data.result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let gitData = try jsonDecoder.decode(MyGithub.self, from: data)
                    print(gitData.name ?? "--")
                    print("Repo:\(gitData.repos ?? 0)")
                    print("Location:\(gitData.location ?? "NULL")")
                } catch let error {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                 print(error.localizedDescription)
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.scrollView.tpKeyboardAvoiding_focusNextTextField() {
            textField.resignFirstResponder()
            //            self.viewModel.login()
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        switch textField {
        case self.emailTF: print("email1:\(textAfterUpdate)")
        case self.passwordTF: print("password1:\(textAfterUpdate)")
            //        case self.emailTF: self.viewModel.email = textAfterUpdate
        //        case self.passwordTF self.viewModel.password = textAfterUpdate
        default: break
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
            //        case self.emailTextField: self.viewModel.email = ""
        //        case self.passwordTextField: self.viewModel.password = ""
        default: break
        }
        return true
    }
}



