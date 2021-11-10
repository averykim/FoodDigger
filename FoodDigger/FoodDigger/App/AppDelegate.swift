//
//  AppDelegate.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/15.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let googleApi = PrivateKey().googleApi

    var window: UIWindow?
    var rootCoordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey(googleApi)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        rootCoordinator = RootCoordinator(navigationController: navigationController)
        rootCoordinator?.start()
        return true
    }
}

