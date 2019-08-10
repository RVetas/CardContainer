//
//  Protocols.swift
//  CardViews
//
//  Created by Виталий Рамазанов on 22/07/2019.
//  Copyright © 2019 SOL. All rights reserved.
//

import UIKit

protocol CardContainerDataSource: class {
    /**
     Defines the number of cards to be shown
    */
    func numberOfCardsToShow() -> Int
    
    /**
     Returns the card for a specified index
    */
    func card(at index: Int) -> SwipeableView
    
    /**
     Defines a swipe type in the container
    */
    func swipeType() -> SwipeType
}

protocol CardContainerDelegate: class {
    /**
     Tells the delegate that the view was swiped
    */
    func card(_ view: SwipeableView, swiped direction: SwipeDirection)
    
    /**
     Tells the delegate that the view at the specified index was swiped
     */
    func card(_ view: SwipeableView, swiped direction: SwipeDirection, at index: Int)
    
    /**
     This method is called when the view is about to appear in the bottom of the card stack.
    */
    func cardContainer(willDisplay view: SwipeableView, at index: Int)
    
    /**
     Tells the delegate that the specified view is selected
    */
    func cardContainer(didSelect view: SwipeableView, at index: Int)
}

extension CardContainerDelegate {
    func card(_ view: SwipeableView, swiped direction: SwipeDirection) {}
    func card(_ view: SwipeableView, swiped direction: SwipeDirection, at index: Int) {}
    func cardContainer(willDisplay view: SwipeableView, at index: Int) {}
    func cardContainer(didSelect view: SwipeableView, at index: Int) {}
}

protocol SwipeableViewDelegate: class {
    var swipeType: SwipeType { get }
    func swipeDidEnd(on view: SwipeableView, swipeDirection: SwipeDirection)
    func selected(view: SwipeableView)
}

protocol CardViewSwipeDelegate: class {
    func swipedUp()
    func swipedDown()
}

enum SwipeDirection: String {
    case up, down, left, right
}

enum SwipeType: String {
    case vertical, horizontal
}
