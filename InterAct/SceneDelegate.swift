//
//  SceneDelegate.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootCoordinator: RootCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow.init(windowScene: scene)
        let navigationController = UINavigationController()
        rootCoordinator = RootCoordinator(navigationController: navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        rootCoordinator?.start()
    }



}

