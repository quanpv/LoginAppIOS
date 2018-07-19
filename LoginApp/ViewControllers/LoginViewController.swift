//
//  LoginViewController.swift
//  LoginApp
//
//  Created by Quan Pham Van on 7/18/18.
//  Copyright © 2018 QuanPV. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class LoginViewController: BaseViewController {

    @IBOutlet var passwordTF: OMGFloatingTextField!
    @IBOutlet var emailTF: OMGFloatingTextField!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapLoginBtn(_ sender: UIButton) {
        print("login btn clicked")
        emailTF?.text = "quanpv.hut@gmail.com"
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
