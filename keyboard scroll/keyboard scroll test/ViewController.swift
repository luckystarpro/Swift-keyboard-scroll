//
//  ViewController.swift
//  keyboard scroll test
//
//  Created by matti on 23.02.15.
//  Copyright (c) 2015 Matti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephoneField: UITextField!
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectGenderButton: UIButton!
    
    var tempTextFieldForConstraint: UITextField!
    var noti : NSNotification!
    
    @IBAction func selectGenderDropdownButton(sender: AnyObject) {
        var sheet: UIActionSheet = UIActionSheet();
        let title: String = NSLocalizedString("selectGenderActionSheetTitle", comment: "");
        sheet.title  = title;
        sheet.delegate = self;
        sheet.addButtonWithTitle(NSLocalizedString("actionSheetCancel", comment: ""));
        sheet.addButtonWithTitle(NSLocalizedString("selectGenderActionSheetOptionFemale", comment: ""));
        sheet.addButtonWithTitle(NSLocalizedString("selectGenderActionSheetOptionMale", comment: ""));
        sheet.cancelButtonIndex = 0;
        sheet.showInView(self.view);
    }
    
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0{
            self.selectGenderButton.setTitle(sheet.buttonTitleAtIndex(buttonIndex), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func proceedToSecondStepButtonPressed(sender: AnyObject) {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        telephoneField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateTextFieldWithKeyboard(notification: NSNotification!) {
//        if(notification != nil){
//            noti = notification
//        }
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as UInt
        if notification.name == UIKeyboardWillShowNotification {
            buttonBottomConstraint.constant = +keyboardSize.height  // move up

        }
        else {
            buttonBottomConstraint.constant = 0 // move down
        }
        view.setNeedsUpdateConstraints()
        let options = UIViewAnimationOptions(curve << 16)
//        UIView.animateWithDuration(duration, delay: 0, options: options,
//            animations: {
//                self.view.layoutIfNeeded()
//            },
//            completion:nil
//        )
        
        UIView.animateWithDuration(duration, delay: 0, options: options, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (Bool) -> Void in
            
            if self.tempTextFieldForConstraint.frame.origin.y-64 < 10 {
                self.buttonBottomConstraint.constant = self.buttonBottomConstraint.constant - (10 - self.tempTextFieldForConstraint.frame.origin.y)-64
            let options = UIViewAnimationOptions(curve << 16)
                UIView.animateWithDuration(duration, delay: 0, options: options,
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion:nil
                )
            }
        }

    }
    
    func keyboardWillShow(notification: NSNotification) {
        animateTextFieldWithKeyboard(notification)
        noti = notification
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateTextFieldWithKeyboard(notification)
        noti = nil
    }
    
    /////////// Hide keyword on tap outside of text area
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    ////////////
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    func textFieldDidBeginEditing(textField: UITextField) {
        tempTextFieldForConstraint = textField
        if(noti != nil){
            self.animateTextFieldWithKeyboard(noti)
        }
    }
}
