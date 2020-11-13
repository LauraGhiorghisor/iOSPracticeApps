//
//  DetailView.swift
//  Hacker
//
//  Created by Laura Ghiorghisor on 16/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://google.com")
    }
}
