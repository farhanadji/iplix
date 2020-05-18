//
//  SceneDelegate.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var firstTabNavigationController : UINavigationController!
    var secondTabNavigationControoller : UINavigationController!
    var thirdTabNavigationController : UINavigationController!
    var fourthTabNavigationControoller : UINavigationController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //        guard let _ = (scene as? UIWindowScene) else { return }
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        let navBarController = UINavigationController(rootViewController: ViewController())
        navBarController.title = "iplix"
        firstTabNavigationController = UINavigationController.init(rootViewController: ViewController())
        secondTabNavigationControoller = UINavigationController.init(rootViewController: CategoriesViewController())
        thirdTabNavigationController = UINavigationController.init(rootViewController: SearchViewController())
        fourthTabNavigationControoller = UINavigationController.init(rootViewController: FavoriteViewController())
        
        tabBarController.viewControllers = [firstTabNavigationController, secondTabNavigationControoller, thirdTabNavigationController, fourthTabNavigationControoller]
        
        let item1 = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let item2 = UITabBarItem(title: "Categories", image: UIImage(systemName: "rectangle.stack.fill"), tag: 1)
        let item3 = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        let item4 = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 3)
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationControoller.tabBarItem = item2
        thirdTabNavigationController.tabBarItem = item3
        fourthTabNavigationControoller.tabBarItem = item4
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 248/255.0, alpha: 1.0)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.windowScene = winScene
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

