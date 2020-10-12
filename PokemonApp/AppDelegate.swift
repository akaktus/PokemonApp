//
//  AppDelegate.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let storyboard = UIStoryboard(name: "ListViewController", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? ListViewController {
            let viewModel = PokemonListViewModel(networkAPI: NetworkLayer())
            viewModel.delegate = viewController
            viewController.viewModel = viewModel
            navigationController.viewControllers = [viewController]
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
}

