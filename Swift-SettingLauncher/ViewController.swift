//
//  ViewController.swift
//  Swift-SettingLauncher
//
//  Created by shin seunghyun on 2020/07/13.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()

    @IBAction func buttonClicked(_ sender: UIButton) {
        settingsLauncher.showSettings()
    }
    
    
    /** Handle Event - Show ViewController For Settings Using navigation Controller **/
    func showControllerForSetting(setting: Setting) {
        /** Handle Event **/
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        /* Navigation Controller가 아니라면 present를 사용해주면 된다. */
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    
}

