# swift_component_setting_launcher

# SettingLauncher.swift

```swift
//
//  SettingLauncher.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/07.
//

import UIKit

/** Component화 한다면 바꿔줘야하는 것들 **/
class Setting: NSObject {
    
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
}

//하나의 데이터타입.
enum SettingName: String {
    case Cancel = "Cancel & Dismiss"
    case Setting = "Setting"
    case TermsPrivacy = "Terms & Privacy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Swift Account"
    
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    /* Set Contents */
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        /* Constraint를 추가했으니 아래 값이 굳이 필요가 없다. */
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        layout.itemSize = CGSize(width: 30, height: 30)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
//        cv.collectionViewLayout.invalidateLayout()
        cv.isScrollEnabled = false
        return cv
    }()
    
    /** Handle Events, for selected menus **/
    /* 이 변수를 `SettingLauncher`를 hosting하는 화면에서 initialize해준다. */
    var homeController: ViewController?
    
    /* Set Menu Items */
    let cellId = "powerCell"
    let cellHeight: CGFloat = 50
        
    /** Component화 한다면 바꿔줘야하는 것들 **/
    /* Set Menu Items */
    let settings: [Setting] = {
        let settingSettings = Setting(name: .Setting, imageName: "square.and.arrow.up")
        let termsAndPrivacySettings = Setting(name: .TermsPrivacy, imageName: "square.and.arrow.down")
        let sendFeedbackSettings = Setting(name: .SendFeedback, imageName: "speaker.zzz")
        let helpSettings = Setting(name: .Help, imageName: "cloud.sun.rain")
        let switchAccount = Setting(name: .SwitchAccount, imageName: "square.and.arrow.up")
        let cancelSettings = Setting(name: .Cancel, imageName: "xmark.seal")
        return [
            settingSettings,
            termsAndPrivacySettings,
            sendFeedbackSettings,
            helpSettings,
            switchAccount,
            cancelSettings
        ]
    }()
    
    func showSettings() {
    
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
//                let window = UIApplication.shared.keyWindow!
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
            return
        }
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5) //투명 background 값 주기
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        window.addSubview(blackView)
        /* Set Contents, 실제 contents를 넣을 view를 그려주고 y 값을 지정해준다.. */
        window.addSubview(collectionView)
        
        /** Set Menu Items **/
        /* Make dynamic Height for Menu Height */
        let height: CGFloat = CGFloat(settings.count) * cellHeight
        
        let y = window.frame.height - height
        
        /* Set Contents */
        //initial value는 y값을 fullsize로 준다. 왜냐하면, animation을 주기 위해서다. 아래서 위로 올라오는 animation 만들기
        collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        blackView.frame = window.frame
        blackView.alpha = 0
        
        /* Set Contents, apply SpringWitnDamping */
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            /* Set Contents, animation 추가 */
            /* collectionView의 크기를 정해준다. */
            self.collectionView.frame = CGRect(x: 0,
                                               y: y,
                                               width: self.collectionView.frame.width,
                                               height: height)
        }, completion: nil)
    }
    
    @objc func handleDismiss() {
        
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
                return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            /* Set Contents, set animation */
            self.collectionView.frame = CGRect(x: 0,
                                               y: window.frame.height,
                                               width: self.collectionView.frame.width,
                                               height: self.collectionView.frame.height)
        }
        
    }
    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "powerCell", for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.row]
        return cell
    }
    
    /* Handle Events */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            else {
                return
        }
        
        //SpringWithDamping
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            /* Set Contents, set animation */
            self.collectionView.frame = CGRect(x: 0,
                                               y: window.frame.height,
                                               width: self.collectionView.frame.width,
                                               height: self.collectionView.frame.height)
        }) { (completed) in
            /* Handle Menu when menu is clicked */
            let setting = self.settings[indexPath.row]
            if setting.name != .Cancel {
                self.homeController?.showControllerForSetting(setting: setting)
            }
        }
    
    }
    
    override init() {
        super.init()
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "powerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name.rawValue
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(systemName: imageName)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(iconImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(30)]-16-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
        
        //center Y로 정렬하기
        addConstraint(NSLayoutConstraint(
            item: iconImageView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: 0))
        
    }
    
}

class BaseCell: UICollectionViewCell {
    
    //Cell을 만들 때, 따로 UINib을 생성하지 않았다면 반드시 호출해야 한다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

extension UIView {
    
    //parameter에 여러 object 넣을 수 있는 함수 만들기
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(
            //V:|-16-[v0]-16-|   =>   Vertically, top, bottom 0 contstant for each
            NSLayoutConstraint.constraints(withVisualFormat: format, // v0(1) => One pixel Tall
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: viewsDictionary)
        )
    }
    
}
```

# hosting view controller, navigation controller여야함.

```swift
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
```
