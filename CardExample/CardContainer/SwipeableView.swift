//
//  SwipeableView.swift
//  CardViews
//
//  Created by Виталий Рамазанов on 22/07/2019.
//  Copyright © 2019 SOL. All rights reserved.
//

import UIKit

class SwipeableView: UIView {
    weak var delegate: SwipeableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 16
        addPanGestureOnCards()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))
    }
    
    func swipedLeft() {}
    func swipedRight() {}
    
    // MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? SwipeableView else { return }
        let point = sender.translation(in: self)
        let centerOfContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfContainer.x, y: centerOfContainer.y + point.y)
        
        let distanceY = centerOfContainer.y - card.center.y
        let distanceX = point.x
        
        let verticalThreshold = card.frame.height * 0.33
        let horizontalThreshold = card.frame.width * 0.25
        
        let cardSwipedRight = (distanceX > 0) && (distanceX > horizontalThreshold)
        let cardSwipedLeft = (distanceX < 0) && (-distanceX > horizontalThreshold)
        let cardSwipedUp = (distanceY > 0) && (verticalThreshold < distanceY)
        let cardSwipedDown = (distanceY < 0) && (verticalThreshold < -distanceY)
        
        if sender.state == .ended {
            if cardSwipedRight {
                swipedRight()
            }
            if cardSwipedLeft {
                swipedLeft()
            }
            
            //Card swiped up
            if cardSwipedUp {
                UIView.animate(withDuration: 0.1, animations: {
                    card.alpha = 0
                    card.center = CGPoint(x: centerOfContainer.x, y: centerOfContainer.y + point.y - 250)
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.delegate?.swipeDidEnd(on: card, swipeDirection: .up)
                })
                return
                
                //Card swiped down
            } else if cardSwipedDown {
                UIView.animate(withDuration: 0.1, animations: {
                    card.center = CGPoint(x: centerOfContainer.x, y: centerOfContainer.y + point.y + 250)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.delegate?.swipeDidEnd(on: card, swipeDirection: .down)
                })
                return
            }
            //Card not swiped
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = centerOfContainer
                self.layoutIfNeeded()
            }
        }
        
    }
    
}
