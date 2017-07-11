//
//  ViewController.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 6/21/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ViewController: ButtonBarPagerTabStripViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .darkGray
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = .darkGray
        }
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        let searchStoryBoard = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "Search")
        let favoritesStoryBoard = UIStoryboard(name: "Favorites", bundle: nil).instantiateViewController(withIdentifier: "Favorites")
        let randomStoryBoard = UIStoryboard(name: "Random", bundle: nil).instantiateViewController(withIdentifier: "Random")
        return [homeStoryboard, searchStoryBoard, favoritesStoryBoard, randomStoryBoard]
    }
}
