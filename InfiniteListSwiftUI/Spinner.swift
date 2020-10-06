//
//  Spinner.swift
//  InfiniteListSwiftUI
//
//  Created by Ashish Tyagi on 06/10/20.
//  Copyright © 2020 Ashish Tyagi. All rights reserved.
//

import SwiftUI
import UIKit

struct Spinner: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
