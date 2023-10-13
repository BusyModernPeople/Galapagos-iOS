//
//  AppDelegate.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import GoogleSignIn
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    let navigationController = UINavigationController()
    
    appCoordinator = AppCoordinator(
      navigationController: navigationController
    )
    
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    
    appCoordinator?.start()
    
    return true
  }
  
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }
      return false
  }
  
}
