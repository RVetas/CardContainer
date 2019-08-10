//
//  CardContainer.swift
//  CardViews
//
//  Created by Виталий Рамазанов on 22/07/2019.
//  Copyright © 2019 SOL. All rights reserved.
//

import UIKit

class CardContainer: UIView {
    // MARK: - Properties
    /**
     Number of cards visible in container
     
     Default = 3
    */
    var cardsToBeVisible = 3
    
    /**
     Horizontal inset of a card in container
     */
    let horizontalInset: CGFloat = 10.0
    /**
     Vertical inset of a card in container
     */
    let verticalInset: CGFloat = 10.0
    
    private var cardViews = [SwipeableView]()
    
    /**
     = number of all cards in datasource minus cards shown
    */
    private var remainingCards = 0
    
    /**
     Number of all cards provided by datasource
    */
    private var numberOfCardsToShow = 0
    
    internal var swipeType: SwipeType = .vertical
    
    private var visibleCards: [SwipeableView] {
        return subviews as? [SwipeableView] ?? []
    }
    
    var dataSource: CardContainerDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: CardContainerDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     This method reloads data in Card Container.
     1. All card views removed
     2. Layout
     3. Adding N cards to container (N = min(numberOfCards, cardsToBeVisible)
    */
    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow
        swipeType = datasource.swipeType()
        
        for index in 0..<min(numberOfCardsToShow, cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: index), atIndex: index)
        }
    }
    
    // MARK: - Configurations
    /**
     This method adds card view to the card container view
    */
    private func addCardView(cardView: SwipeableView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        
        let cardIndex = numberOfCardsToShow - remainingCards
        delegate?.cardContainer(willDisplay: cardView, at: cardIndex)
        
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    /**
     This method creates card view's frame based on index of a card
    */
    private func addCardFrame(index: Int, cardView: SwipeableView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    /**
     This method removes all card views from container
    */
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        
        cardViews = []
    }
}

extension CardContainer: SwipeableViewDelegate {
    func selected(view: SwipeableView) {
        guard let datasource = dataSource else { return }
        let index = datasource.numberOfCardsToShow() - remainingCards - cardsToBeVisible
        delegate?.cardContainer(didSelect: view, at: index)
    }
    
    func swipeDidEnd(on view: SwipeableView, swipeDirection: SwipeDirection) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        let cardIndex = datasource.numberOfCardsToShow() - remainingCards - cardsToBeVisible
        delegate?.card(view, swiped: swipeDirection)
        delegate?.card(view, swiped: swipeDirection, at: cardIndex)
        
        if remainingCards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingCards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.1) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                }
            }
        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.1) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                }
            }
        }
    }
}
