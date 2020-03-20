//
//  BaseViewController.swift
//  Flokq
//
//  Created by Appy on 19/04/19.
//  Copyright © 2019 Appy. All rights reserved.
//

import UIKit

//MARK: UIScrollView Action Control Setup
class BaseViewController: UIViewController,UIGestureRecognizerDelegate{

    var swipeLeft : UISwipeGestureRecognizer?
    var tapRecognizer : UITapGestureRecognizer?
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupGesture()
    }
    
    func setupGesture()
    {
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.handleSingleTap(_:)))
        self.tapRecognizer!.numberOfTapsRequired = 1
        self.tapRecognizer!.cancelsTouchesInView = false
        self.view.addGestureRecognizer(self.tapRecognizer!)
        
        
    }
    
    func removeGesture()
    {
        
        if self.tapRecognizer != nil
        {
            self.view.removeGestureRecognizer(self.tapRecognizer!)
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        
        return true;
    }
    
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
