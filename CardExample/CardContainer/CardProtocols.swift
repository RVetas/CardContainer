//
//  Protocols.swift
//  CardViews
//
//  Created by Виталий Рамазанов on 22/07/2019.
//  Copyright © 2019 SOL. All rights reserved.
//

import UIKit

protocol CardContainerDataSource: class {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeableView
    func emptyView() -> UIView?
    func swipeType() -> SwipeType
}

protocol CardContainerSwipeDelegate: class {
    func card(_ view: SwipeableView, swiped direction: SwipeDirection)
}

protocol SwipeableViewDelegate: class {
    var swipeType: SwipeType { get }
    func swipeDidEnd(on view: SwipeableView, swipeDirection: SwipeDirection)
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
