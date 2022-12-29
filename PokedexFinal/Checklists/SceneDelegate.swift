/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  let dataModel = DataModel()



  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let tabBarController = window!.rootViewController as! UITabBarController
    let navController = tabBarController.viewControllers![0] as! UINavigationController
    let controller = navController.viewControllers[0] as! AllListsViewController
    controller.dataModel = dataModel
    controller.managedObjectContext = managedObjectContext

    
    listenForFatalCoreDataNotifications()

  }

  func sceneDidDisconnect(_ scene: UIScene) {
    saveData()
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
    saveData()
    saveContext()
  }

  // MARK: - Helper Methods
  func saveData() {
    dataModel.saveChecklists()
  }
  

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FavoritePokemons")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Could not load data store: \(error)")
      }
    }
    return container
  }()
  
  lazy var managedObjectContext = persistentContainer.viewContext
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  // MARK: - Helper methods
  func listenForFatalCoreDataNotifications() {
    NotificationCenter.default.addObserver(
      forName: dataSaveFailedNotification,
      object: nil,
      queue: OperationQueue.main
    ) { _ in
      let message = """
      There was a fatal error in the app and it cannot continue.
      
      Press OK to terminate the app. Sorry for the inconvenience.
      """
      let alert = UIAlertController(
        title: "Internal Error",
        message: message,
        preferredStyle: .alert)
      
      let action = UIAlertAction(title: "OK", style: .default) { _ in
        let exception = NSException(
          name: NSExceptionName.internalInconsistencyException,
          reason: "Fatal Core Data error",
          userInfo: nil)
        exception.raise()
      }
      alert.addAction(action)
      
      let tabController = self.window!.rootViewController!
      tabController.present(
        alert,
        animated: true,
        completion: nil)
    }
  }

}


