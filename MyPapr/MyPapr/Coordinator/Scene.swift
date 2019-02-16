//
//  Scene.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit


protocol TargetScene {
    var transition: SceneTransitionType { get }
}



enum Scene {
    case papr
}



extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .papr:
            let paprTabBarController = PaprTabBarController()
            
            var homeVc = HomeViewController(collectionViewLayout: PinterestLayout(numberOfColumns: 1))
            let homeViewModel = HomeViewModel()
            let rootHome = UINavigationController(rootViewController: homeVc)
            homeVc.bind(to: homeViewModel)
            
            let collectionsVc = CollectionsViewController()
            let rootCollections = UINavigationController(rootViewController: collectionsVc)
            
            let searchVc = SearchViewController()
            let rootSearch = UINavigationController(rootViewController: searchVc)
            
            rootHome.tabBarItem = UITabBarItem(
                title: "Photo",
                image: #imageLiteral(resourceName: "photo-white"),
                tag: 0)
            
            rootCollections.tabBarItem = UITabBarItem(
                title: "Collections",
                image: #imageLiteral(resourceName: "collections-white"),
                tag: 1)
            
            rootSearch.tabBarItem = UITabBarItem(
                title: "Search",
                image: #imageLiteral(resourceName: "search-white"),
                tag: 2)
            
            paprTabBarController.viewControllers = [rootHome, rootCollections, rootSearch]
            return .tabBar(paprTabBarController) 
        }
    }
}
