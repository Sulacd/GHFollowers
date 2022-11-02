//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/16/22.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    // Either adds or removes a follower from persisted data
    // The completion handler parameter is used to return an error if something goes wrong
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            // If we successfully retrieved the persisted data array of favorites, we can either add or remove a follower
            case .success(var favorites):
            
                switch actionType {
                case .add:
                    // When adding a new favorite, first checks to see if that follower is already in the favorites array
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    // If the new favorite is not persisted, append it to the copied array that will be persisted
                    favorites.append(favorite)
                case .remove:
                    // Removes all instances of the specified user in the copied favorites array
                    favorites.removeAll {$0.login == favorite.login}
                }
                // Saves the copied array in User defaults and passes back an error if something went wrong while encoding
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    // Retrieves the favorite followers array from User defaults
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            // If trying to access the persisted data for the first time, returns an empty favorites list
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            // Decode the JSON data into an array of followers
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    // Saves the favorite followers array to User Defaults
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
