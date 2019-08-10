//
//  SwipeableView.swift
//  CardViews
//
//  Created by Виталий Рамазанов on 22/07/2019.
//  Copyright © 2019 SOL. All rights reserved.
//

import UIKit

class SwipeableView: UIView {
    weak var delegate: SwipeableViewDelegate? {
        didSet {
            setSwipeType()
        }
    }
    /**
     Vertical threshold. If vertical deviation > vertical threshold * card.height, card will be swiped. Default is 0.33
     ## Vertical threshold must be in 0...1 ##
    */
    var verticalThreshold: CGFloat = 0.33
    
    /**
     Horizontal threshold. If horizontal deviation > vertical threshold * card.width, card will be swiped. Default is 0.5
     ## Horizontal threshold must be in 0...1 ##
     */
    var horizontalThreshold: CGFloat = 0.5
    
    /**
     Swipe direction
    */
    var swipeType: SwipeType = .vertical
    
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:))))
    }
    
    func setSwipeType() {
        guard let delegate = delegate else { return }
        swipeType = delegate.swipeType
    }
    
    func swipedLeft() {}
    func swipedRight() {}
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        delegate?.selected(view: self)
    }
    
    // MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? SwipeableView else { return }
        let point = sender.translation(in: self)
        let centerOfContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        switch swipeType {
        case .vertical:
            card.center = CGPoint(x: centerOfContainer.x, y: centerOfContainer.y + point.y)
        case .horizontal:
            card.center = CGPoint(x: centerOfContainer.x + point.x, y: centerOfContainer.y)
        }
        
        let distanceY = centerOfContainer.y - card.center.y
        let distanceX = point.x
        
        let yThreshold = card.frame.height * verticalThreshold
        let xThreshold = card.frame.width * horizontalThreshold
        
        let cardSwipedRight = (distanceX > 0) && (distanceX > xThreshold)
        let cardSwipedLeft = (distanceX < 0) && (-distanceX > xThreshold)
        let cardSwipedUp = (distanceY > 0) && (yThreshold < distanceY)
        let cardSwipedDown = (distanceY < 0) && (yThreshold < -distanceY)
        
        if sender.state == .ended {
            switch swipeType {
            case .vertical:
                if cardSwipedUp {
                    UIView.animate(withDuration: 0.1, animations: {
                        card.alpha = 0
                        card.center = CGPoint(x: centerOfContainer.x, y: centerOfContainer.y + point.y - 250)
                        self.layoutIfNeeded()
                    }, completion: { _ in
                        self.delegate?.swipeDidEnd(on: card, swipeDirection: .up)
                    })
                    return
                }
                else if cardSwipedDown {
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
                
            case .horizontal:
                if cardSwipedLeft {
                    UIView.animate(withDuration: 0.1, animations: {
                        card.center = CGPoint(x: centerOfContainer.x + point.x - 250, y: centerOfContainer.y)
                        card.alpha = 0
                        self.layoutIfNeeded()
                    }, completion: { _ in
                        self.delegate?.swipeDidEnd(on: card, swipeDirection: .left)
                    })
                } else if cardSwipedRight {
                    UIView.animate(withDuration: 0.1, animations: {
                        card.center = CGPoint(x: centerOfContainer.x + point.x + 250, y: centerOfContainer.y)
                        card.alpha = 0
                        self.layoutIfNeeded()
                    }, completion: { _ in
                        self.delegate?.swipeDidEnd(on: card, swipeDirection: .right)
                    })
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
    
}
