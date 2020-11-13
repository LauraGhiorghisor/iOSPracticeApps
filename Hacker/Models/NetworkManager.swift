//
//  NetworkManager.swift
//  Hacker
//
//  Created by Laura Ghiorghisor on 16/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import Foundation

// this uses the obs objkect protocol. our posts array will be looked at as it has the @published
class NetworkManager: ObservableObject {
    @Published var posts = [Post]()
    
    func fetchData() {
        
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Result.self, from: safeData)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                            }
                            
                        } catch {
                            print (error)
                        }
                        
                    }
                    
                }
            }
            task.resume()
        }
    }
}
