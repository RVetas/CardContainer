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
    /**
     Vertical threshold. If vertical deviation > vertical threshold * card.height, card will be swiped.
     ## Vertical threshold must be in 0...1 ##
    */
    var verticalThreshold: CGFloat = 0.33
    
    /**
     Horizontal threshold. If horizontal deviation > vertical threshold * card.width, card will be swiped.
     ## Horizontal threshold must be in 0...1 ##
     */
    var horizontalThreshold: CGFloat = 0.25
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        
        let yThreshold = card.frame.height * verticalThreshold
        let xThreshold = card.frame.width * horizontalThreshold
        
        let cardSwipedRight = (distanceX > 0) && (distanceX > xThreshold)
        let cardSwipedLeft = (distanceX < 0) && (-distanceX > xThreshold)
        let cardSwipedUp = (distanceY > 0) && (yThreshold < distanceY)
        let cardSwipedDown = (distanceY < 0) && (yThreshold < -distanceY)
        
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
