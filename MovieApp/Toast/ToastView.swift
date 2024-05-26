//
//  ToastView.swift
//  MovieApp
//
//  Created by Nikola Savic on 26.5.24..
//

import SwiftUI

public struct ToastView: View {
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  public var body: some View {
    HStack(alignment: .center, spacing: 12) {
        
      Text(message)
        .font(Font.caption)
        .foregroundColor(Color.primaryBackground)
      
      Spacer(minLength: 10)
      
      Button {
        onCancelTapped()
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(style.themeColor)
      }
    }
    .padding()
    .frame(minWidth: 0, maxWidth: width)
    .background(Color.white)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .opacity(0.1)
        .border(style.themeColor)
    )
    .padding(.horizontal, 16)
  }
}

public struct ToastView_Previews: PreviewProvider {
    public static var previews: some View {
        ToastView(
            style: .info,
            message: "TEST",
            onCancelTapped: {}
        )
    }
}
