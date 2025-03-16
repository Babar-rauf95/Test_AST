//
//  CoreDataManager.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save User Session
    func saveUserSession(userID: String, email: String, role: String) {
        let session = UserSession(context: context)
        session.userID = userID
        session.email = email
        session.role = role
        session.timestamp = Date()  // Store the current timestamp

        do {
            try context.save()
        } catch {
            print("Failed to save user session: \(error.localizedDescription)")
        }
    }

    // Fetch User Session
    func getUserSession() -> UserSession? {
        let fetchRequest: NSFetchRequest<UserSession> = UserSession.fetchRequest()

        do {
            let sessions = try context.fetch(fetchRequest)
            if let session = sessions.first {
                let elapsedTime = Date().timeIntervalSince(session.timestamp ?? Date())
                if elapsedTime < 3600 {  // Check if session is within 60 minutes
                    return session
                } else {
                    deleteUserSession()
                    return nil
                }
            }
        } catch {
            print("Failed to fetch user session: \(error.localizedDescription)")
        }
        return nil
    }

    // Delete User Session (Logout)
    func deleteUserSession() {
        let fetchRequest: NSFetchRequest<UserSession> = UserSession.fetchRequest()

        do {
            let sessions = try context.fetch(fetchRequest)
            for session in sessions {
                context.delete(session)
            }
            try context.save()
        } catch {
            print("Failed to delete user session: \(error.localizedDescription)")
        }
    }
}
