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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //return [HomeViewController(), SearchViewController(), FavoritesViewController(), RandomViewController()]
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        let searchStoryBoard = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "Search")
        let favoritesStoryBoard = UIStoryboard(name: "Favorites", bundle: nil).instantiateViewController(withIdentifier: "Favorites")
        let randomStoryBoard = UIStoryboard(name: "Random", bundle: nil).instantiateViewController(withIdentifier: "Random")
        return [homeStoryboard, searchStoryBoard, favoritesStoryBoard, randomStoryBoard]
    }
}
