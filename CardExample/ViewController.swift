//
//  ViewController.swift
//  CardExample
//
//  Created by Виталий Рамазанов on 04/08/2019.
//  Copyright © 2019 VR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardContainer: CardContainer!
    let colors: [UIColor] = [.black, .blue, .brown, .orange, .yellow, .magenta, .purple, .green, .gray, .red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardContainer.delegate = self
        cardContainer.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardContainer.dataSource = self
    }

}

extension ViewController: CardContainerDataSource {
    func numberOfCardsToShow() -> Int {
        return colors.count
    }
    
    func card(at index: Int) -> SwipeableView {
        let card = SwipeableView()
        card.backgroundColor = colors[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }

    
}

extension ViewController: CardContainerSwipeDelegate {
    func card(_ view: SwipeableView, swiped direction: SwipeDirection) {
        print("\(String(describing: view.backgroundColor)) card swiped \(direction)")
    }
    
}
