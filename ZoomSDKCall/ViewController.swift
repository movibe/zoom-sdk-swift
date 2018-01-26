//
//  ViewController.swift
//  ZoomSDKCall
//
//  Created by Willian Angelo on 26/01/2018.
//  Copyright © 2018 Willian Angelo. All rights reserved.
//

import UIKit
import ZoomAuthentication

let APP_USER = "current_user"
let APP_TOKEN = "zoom_token"
let APP_CRIPTO = "CRIPTO"

class ViewController: UIViewController, ZoomEnrollmentDelegate, ZoomAuthenticationDelegate {
    func onZoomEnrollmentResult(result: ZoomEnrollmentResult) {
        print("\(result.status)")
        
        //
        // retrieve the enrollment audit trail image
        // note: this is enabled on a per-application basis
        // please contact support@zoomlogin.com to request access
        //
        if let auditTrail = result.faceMetrics?.auditTrail {
            print("Audit trail image count: \(auditTrail.count)")
        }
    }
    
    func onZoomAuthenticationResult(result: ZoomAuthenticationResult) {
        print("\(result.status)")
        
        if let secret = result.secret {
            print("Secret data returned from successful authentication: \(secret)")
        }
        
        //
        // retrieve the enrollment audit trail image
        // note: this is enabled on a per-application basis
        // please contact support@zoomlogin.com to request access
        //
        if let auditTrail = result.faceMetrics?.auditTrail {
            print("Audit trail image count: \(auditTrail.count)")
        }
    }
    
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var enrollButton: UIButton!
    @IBOutlet weak var authButton: UIButton!
    
    func onEnrollButtonClicked() {
        let enrollVC = ZoomSDK.createEnrollmentVC()
        enrollVC.prepareForEnrollment (
            delegate: self,
            userID: APP_USER,
            applicationPerUserEncryptionSecret: APP_CRIPTO,
            secret: "secret_data"
        )
        
        enrollVC.modalTransitionStyle = .coverVertical
        enrollVC.modalPresentationStyle = .overFullScreen
        self.present(enrollVC, animated: true, completion: nil)
    }
    
    func loadRecallableCustomizations() {
        
        ZoomSDK.setLanguage("pt-BR")
        
//        if let authState = UserDefaults.standard.object(forKey: "authState") as? Bool {
//            currentCustomization.showAuthenticationIntroLogo = authState
//        }
//        if let enrollState = UserDefaults.standard.object(forKey: "enrollState") as? Bool {
//            currentCustomization.showEnrollmentIntro = enrollState
//        }
//        if let language = UserDefaults.standard.object(forKey: "language") as? Int {
//            switch language {
//            case 1:
//                ZoomSDK.setLanguage("en")
//            case 2:
//                ZoomSDK.setLanguage("pt-BR")
//            default:
//                ZoomSDK.setLanguage("")
//            }
//        }
    }
    
    @IBAction func onAuthenticateButtonClicked(_ sender: Any) {
        DispatchQueue.main.async {
            let authVC = ZoomSDK.createAuthenticationVC()
            authVC.prepareForAuthentication(
                delegate: self,
                userID: APP_USER,
                applicationPerUserEncryptionSecret: APP_CRIPTO
            )
            
            authVC.modalTransitionStyle = .coverVertical
            authVC.modalPresentationStyle = .overFullScreen
            self.present(authVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // We want to disable enroll and auth until App Token has been validated
        //
//        enrollButton.isEnabled = false
//        authButton.isEnabled = false
        
        //
        // initialize ZoomSDK
        //
        // create the customization object
        var customization: ZoomCustomization = ZoomCustomization()
        
        // dark mode theme
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor,
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor,
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor,
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor
        ]
        
        customization.mainBackgroundColors = [ UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9), UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9) ]
        customization.tabBackgroundColor         = UIColor(red:0.14, green:0.13, blue:0.14, alpha:1.0)
        customization.tabBackgroundSelectedColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        customization.tabTextColor               = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        customization.tabTextSelectedColor       = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        customization.tabBackgroundSuccessColor  = UIColor(red:0.00, green:0.61, blue:0.27, alpha:1.0)
        customization.tabTextSuccessColor        = UIColor(red:1.0,  green:1.0,  blue:1.0,  alpha:1.0)
        customization.resultsScreenBackgroundColor = [ UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9), UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9) ]
        customization.progressSpinnerColor1 = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9)
        customization.progressSpinnerColor2 = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9)
        customization.progressBarColor = gradientLayer
        
        // brand logo and pre-enrollment screen title and text
//        customization.brandingLogo = UIImage(named: "custom_bank_logo")
//        customization.preEnrollScreenTitle = "Selfie Pay Enrollment"
//        customization.preEnrollScreenSubtext = "Leave password behind and pay with your face!\n\nThis text is customizable in the ZoOm SDK."
        
        // logo intro before enrollment and authentication
        customization.showEnrollmentIntro = false
        customization.showAuthenticationIntroLogo = false
        
        
        ZoomSDK.initialize(
            appToken: APP_TOKEN,
            enrollmentStrategy: .ZoomOnly,
             interfaceCustomization: customization,
            completion: { (appTokenValidated: Bool) -> Void in
                //
                // We want to ensure that App Token is valid before enabling Enroll and Auth button
                //
                if appTokenValidated {
                    print("AppToken validated successfully")
//                    self.enrollButton.isEnabled = true
//                    self.authButton.isEnabled = true
                    self.onEnrollButtonClicked()
                }
                else {
                    print("AppToken did not validate.  If Zoom ViewController's are launched, user will see an app token error state")
                }
        })
    }
    
//    override func viewDidLayoutSubviews() {
//
//        let colors = [UIColor(red: 0.04, green: 0.71, blue: 0.64, alpha: 1), UIColor(red: 0.07, green: 0.57, blue: 0.76, alpha: 1)]
//
////        ZoomTheme.configureGradientBackground(colors: colors, inLayer: backgroundView.layer)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//extension ZoomAuthenticationBasicAppViewController: ZoomEnrollmentDelegate {
//    func onZoomEnrollmentResult(result r: ZoomEnrollmentResult) {
//
//        print("Application received enrollment result from Zoom SDK.")
//
//        switch(r.status) {
//        case .UserWasEnrolled:
//            print("(r.status)")
//        case .FailedBecauseAppTokenNotValid:
//            print("(r.status)")
//        case .FailedBecauseUserCancelled:
//            print("(r.status)")
//        case .FailedBecauseCameraPermissionDeniedByUser:
//            print("(r.status)")
//        case .FailedBecauseCameraPermissionDeniedByAdministrator:
//            print("(r.status)")
//        case .FailedBecauseOfTimeout:
//            print("(r.status)")
//        case .FailedBecauseOfOSContextSwitch:
//            print("(r.status)")
//        case .FailedBecauseOfDiskWriteError:
//            print("(r.status)")
//        case .FailedBecauseUserCouldNotValidateFingerprint:
//            print("(r.status)")
//        case .FailedBecauseFingerprintDisabled:
//            print("(r.status)")
//        default:
//            print("(r.status)")
//        }
//        print("(r)")
//    }
//
//    func onZoomEnrollmentResult(result: ZoomEnrollmentResult) {
//        print("\(result.status)")
//
//        //
//        // retrieve the enrollment audit trail image
//        // note: this is enabled on a per-application basis
//        // please contact support@zoomlogin.com to request access
//        //
//        if let auditTrail = result.faceMetrics?.auditTrail {
//            print("Audit trail image count: \(auditTrail.count)")
//        }
//    }
//
//    func onZoomAuthenticationResult(result: ZoomAuthenticationResult) {
//        print("\(result.status)")
//
//        if let secret = result.secret {
//            print("Secret data returned from successful authentication: \(secret)")
//        }
//
//        //
//        // retrieve the enrollment audit trail image
//        // note: this is enabled on a per-application basis
//        // please contact support@zoomlogin.com to request access
//        //
//        if let auditTrail = result.faceMetrics?.auditTrail {
//            print("Audit trail image count: \(auditTrail.count)")
//        }
//    }
//}

//extension ViewController: ZoomAuthenticationDelegate {
//    func onZoomAuthenticationResult(result r: ZoomAuthenticationResult){
//
//        switch(r.status) {
//        case .UserWasAuthenticated:
//            print("(r.status)")
//        case .FailedBecauseAppTokenNotValid:
//            print("(r.status)")
//        case .FailedBecauseUserCancelled:
//            print("(r.status)")
//        case .FailedBecauseUserMustEnroll:
//            print("(r.status)")
//        case .FailedBecauseUserFailedAuthentication:
//            print("(r.status)")
//        case .FailedBecauseCameraPermissionDenied:
//            print("(r.status)")
//        case .FailedToAuthenticateTooManyTimesAndUserWasDeleted:
//            print("(r.status)")
//        case .FailedBecauseOfTimeout:
//            print("(r.status)")
//        case .FailedBecauseOfOSContextSwitch:
//            print("(r.status)")
//        default:
//            print("(r.status)")
//        }
//        print("(r)")
//    }
//}

