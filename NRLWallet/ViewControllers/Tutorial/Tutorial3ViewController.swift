//
//  Tutorial3ViewController.swift
//  NRLWallet
//
//  Created by dev on 18/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class Tutorial3ViewController: UIViewController {
    
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.btnCreateAccount.layer.cornerRadius = 4
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y:2)
        self.cardView.layer.borderWidth = 2
        self.cardView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 0.4).cgColor
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mnemonic", bundle: nil)
        let mnemonicViewController = storyboard.instantiateViewController(withIdentifier: "MnemonicNavVC")
        let window = UIApplication.shared.keyWindow
        
        if let window = window {
            UIView.transition(with: window, duration: 0.05, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = mnemonicViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}