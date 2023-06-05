//
//  BouncyArrowView.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-06-05.
//

import SwiftUI



struct BouncyArrowView: View {
    @State private var arrowOffset: CGFloat = 0.0
    let rotationAngle: Angle

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear // Add a background color if needed

                Path { path in
                    let arrowHeight: CGFloat = 20
                    let arrowWidth: CGFloat = 30
                    let arrowStartX = geometry.size.width - arrowHeight
                    let arrowStartY = geometry.size.height / 2 - arrowWidth / 2

                    path.move(to: CGPoint(x: arrowStartX, y: arrowStartY))
                    path.addLine(to: CGPoint(x: arrowStartX + arrowHeight, y: arrowStartY + arrowWidth / 2))
                    path.addLine(to: CGPoint(x: arrowStartX, y: arrowStartY + arrowWidth))
                }
                .fill(Color.black)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .rotationEffect(rotationAngle)
                .offset(x: -self.arrowOffset)
                .onAppear {
                    animateArrow()
                }
            }
        }
    }

    func animateArrow() {
        withAnimation(Animation.easeInOut(duration: 0.7).repeatForever()) {
            self.arrowOffset = 10
        }
    }
}
