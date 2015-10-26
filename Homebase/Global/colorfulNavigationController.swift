//
//  colorfulNavigationController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/20/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import ChameleonFramework

class colorfulNavigationController: UINavigationController {

    
                //GradientColor(UIGradientStyle.TopToBottom, navigationBarAppearace.frame, [HexColor("FF5E3A"), HexColor("FF2A68")])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        
        //makes the frame which includes navbar and status bar
        let navBarRect = CGRectMake(
            navigationBar.frame.minX,
            UIApplication.sharedApplication().statusBarFrame.minY,
            navigationBar.frame.width,
            navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height)
        
        let mainColor = HexColor("5AD427")
        let mainGradient = GradientColor(UIGradientStyle.TopToBottom, navBarRect, [UIColor(hexString: "A4E786"), UIColor(hexString: "5AD427")])
        
        self.navigationBar.barTintColor = mainColor
        
        UIApplication.sharedApplication().statusBarFrame.minY

        navigationBar.tintColor = UIColor(complementaryFlatColorOf: mainGradient)//.lightenByPercentage(20.0)
        navigationBar.barTintColor = mainGradient
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainGradient, true)]
        // navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainColor, true), NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = ContrastColorOf(mainGradient, true)
        tabBarAppearance.barTintColor = mainColor.lightenByPercentage(0.05)
        
    }
    
    func generateAppTheme(){
        let navBarRect = CGRectMake(
            navigationBar.frame.minX,
            UIApplication.sharedApplication().statusBarFrame.minY,
            navigationBar.frame.width,
            navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height)
        
        let mainColor = RandomFlatColorWithShade(.Light)
        let mainGradient = GradientColor(
            UIGradientStyle.TopToBottom,
            navBarRect,
            [mainColor.darkenByPercentage(0.2), mainColor]
        )
        
        self.navigationBar.barTintColor = mainColor
        
        UIApplication.sharedApplication().statusBarFrame.minY
        
        navigationBar.tintColor = UIColor(complementaryFlatColorOf: mainGradient).lightenByPercentage(0.2)
        navigationBar.barTintColor = mainGradient
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainGradient, true)]
        // navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainColor, true), NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(complementaryFlatColorOf: mainGradient).lightenByPercentage(0.2)
        tabBarAppearance.barTintColor = mainColor.lightenByPercentage(0.1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
