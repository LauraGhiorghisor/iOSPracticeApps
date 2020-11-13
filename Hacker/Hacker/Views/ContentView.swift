//
//  ContentView.swift
//  Hacker
//
//  Created by Laura Ghiorghisor on 16/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
    
        NavigationView {
            List(networkManager.posts) { post in
                //
                NavigationLink(destination: DetailView(url: post.url)) {
                    HStack {
                                       Text(String(post.points))
                                       Text(post.title)
                                   }
                }
                
               
            }
        .navigationBarTitle("Hacker News")
        }
        .onAppear {
            self.networkManager.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//let posts = [
//    Post(id: "1", title: "hello1"),
//    Post(id: "2", title: "hello1"),
//    Post(id: "3", title: "hello1")
//]
