//
//  FailedView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import SwiftUI

struct FailedView: View {
    let errorMessage: String
    let tryAgainAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("Error\n\(errorMessage)")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                tryAgainAction()
            }) {
                Text("Try again")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#if DEBUG

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView(errorMessage: "Something went wrong", tryAgainAction: {})
    }
}

#endif
