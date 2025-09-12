//
//  BGTaskManager.swift
//  SwiftAVPlayer
//
//  Created by Hobin Han on 9/10/25.
//
//  [Reference]
//  - [Advances in App Background Execution](https://developer.apple.com/videos/play/wwdc2019/707/)
//  - [Configuring background execution modes](https://developer.apple.com/documentation/xcode/configuring-background-execution-modes)
//  - [Using background tasks to update your app](https://developer.apple.com/documentation/UIKit/using-background-tasks-to-update-your-app)
//  - [Starting and Terminating Tasks During Development](https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development)
//
//  [Learn More]
//  - [Performing long-running tasks on iOS and iPadOS](https://developer.apple.com/documentation/backgroundtasks/performing-long-running-tasks-on-ios-and-ipados)
//

@preconcurrency import BackgroundTasks

actor BGTaskManager {
    static let refreshIdentifier    = "com.hobin.SwiftAVPlayer.background.refresh"
    
    let queue = OperationQueue()
    
    static var shared: BGTaskManager = {
        BGTaskManager()
    }()
    
    private init() {
        // 👉 register background tasks here...
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BGTaskManager.refreshIdentifier, using: nil) { task in
            // 👉 handle background tasks here...
            guard let task = task as? BGAppRefreshTask else { return }
            Self.handleAppRefresh(task: task)
        }
    }
    
    static func registerAppRefreshScheduler() {
        // 👉 register background tasks here...
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BGTaskManager.refreshIdentifier, using: nil) { task in
            // 👉 handle background tasks here...
            guard let task = task as? BGAppRefreshTask else { return }
            Self.handleAppRefresh(task: task)
        }
    }
    
    static func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.refreshIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // no earlier than 15 min
        
        do {
            // 👉 reschedule background tasks here...
            // the new submission replaces the previous submission.
            try BGTaskScheduler.shared.submit(request)
            
            // If you want to trigger launchHandler immedieately, create breakpoint here and invoke the command below.
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.hobin.SwiftAVPlayer.background.refresh"]
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    static private func handleAppRefresh(task: BGAppRefreshTask) {
        print("handleAppRefresh", UserDefaults.standard.lastRefreshDateString)
        scheduleAppRefresh()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.addOperation {
            UserDefaults.standard.lastRefreshDateString = Date().description
            task.setTaskCompleted(success: true) // 👉 background task must be completed!!
        }
        
        // 👉 cancel your tasks here...
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
    }
}
