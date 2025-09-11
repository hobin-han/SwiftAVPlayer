//
//  BGTaskManager.swift
//  SwiftAVPlayer
//
//  Created by Hobin Han on 9/10/25.
//

@preconcurrency import BackgroundTasks

actor BGTaskManager {
    static let refreshIdentifier    = "com.hobin.SwiftAVPlayer.background.refresh"
    static let updateIdentifier     = "com.hobin.SwiftAVPlayer.background.update_db"
    
    static var shared: BGTaskManager = {
        BGTaskManager()
    }()
    private init() {
        // https://developer.apple.com/documentation/backgroundtasks/performing-long-running-tasks-on-ios-and-ipados
        // BGContinuedProcessingTaskRequest - #available(iOS 26.0, *)
        
        // register a background task for refreshing
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BGTaskManager.refreshIdentifier, using: nil) { task in
            Self.handleAppRefresh(task: task as! BGAppRefreshTask) // downcast available (BGAppRefreshTaskRequest)
        }
        // register a background task for updating database
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BGTaskManager.updateIdentifier, using: nil) { task in
            Self.handleDatabaseUpdate(task: task as! BGProcessingTask) // downcast available (BGProcessingTaskRequest)
        }
    }
    
    // https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development
    static func scheduleAppRefresh() {
        print("scheduleAppRefresh", Date())
        let request = BGAppRefreshTaskRequest(identifier: Self.refreshIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // no earlier than 15 min
        
        do {
            try BGTaskScheduler.shared.submit(request) // the new submission replaces the previous submission.
            
            // If you want to trigger launchHandler immedieately, create breakpoint here and invoke the command below.
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.hobin.SwiftAVPlayer.background.refresh"]
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    static func scheduleDatabaseUpdate() {
        print("scheduleDatabaseUpdate", Date())
        let request = BGProcessingTaskRequest(identifier: Self.updateIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // no earlier than 15 min
        
        do {
            try BGTaskScheduler.shared.submit(request) // the new submission replaces the previous submission.
            
            // If you want to trigger launchHandler immedieately, create breakpoint here and invoke the command below.
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.hobin.SwiftAVPlayer.background.update_db"]
        } catch {
            print("Could not schedule database update: \(error)")
        }
    }
    
    static private func handleAppRefresh(task: BGAppRefreshTask) {
        print("handleAppRefresh", Date())
        scheduleAppRefresh()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.addOperation {
            // do something
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                task.setTaskCompleted(success: true)
            }
        }
        
        task.expirationHandler = {
            print("app refreshing expired")
            queue.cancelAllOperations()
        }
    }
    
    static private func handleDatabaseUpdate(task: BGProcessingTask) {
        print("handleDatabaseUpdate", Date())
        scheduleDatabaseUpdate()
        
        task.expirationHandler = {
            print("database updating expired")
        }
    }
}
