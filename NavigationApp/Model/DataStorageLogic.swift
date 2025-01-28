//
//  DataStorageLogic.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class DataStorageManager {
    
    static let shared = DataStorageManager()
    private let ref = Database.database().reference()
    private var userId: String?
    
    private init() {
        authenticateAnonymously()
    }
    
    // MARK: - Authenticate Anonymously
    private func authenticateAnonymously() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            print("Session restored with UID: \(user.uid)")
        } else {
            Auth.auth().signInAnonymously { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                if let user = authResult?.user {
                    self.userId = user.uid
                }
            }
        }
    }
    
    // MARK: - Add Route (with User-specific Data)
    internal func addRoute(route: String, averageSpeed speed: Double) {
        guard let userId = userId else {
            print("User is not authenticated")
            return
        }

        let routeId = route
        let routeRef = self.ref.child("routes").child(userId).child(routeId)
        
        routeRef.observeSingleEvent(of: .value) { snapshot in
            if var routeInfo = snapshot.value as? [String: Any] {
                var frequency = routeInfo["frequency"] as! Int
                frequency += 1
                routeInfo["frequency"] = frequency
                routeInfo["average_speed"] = speed
                routeRef.setValue(routeInfo)
            } else {
                let routeInfo = [
                    "route": routeId,
                    "average_speed": speed,
                    "frequency": 1
                ] as [String: Any]
                routeRef.setValue(routeInfo)
            }
        }
        
        getRoutes { result in
            switch result {
            case .success(let value): print(value)
            case .failure(_):
                print("Couldn't fetch data")
            }
        }
    }
    
    // MARK: - Fetch Routes (User-specific)
    internal func getRoutes(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        guard let userId = userId else {
            print("User is not authenticated")
            completion(.failure(DataError.fetchDataError))
            return
        }

        ref.child("routes").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            guard let routesDict = snapshot.value as? [String: Any] else {
                completion(.failure(DataError.fetchDataError))
                return
            }
            
            let routesData = routesDict.compactMap { $0.value as? [String: Any] }
            completion(.success(routesData))
        }) { error in
            completion(.failure(error))
        }
    }
}

