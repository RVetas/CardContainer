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
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    
    var swipeDirection: SwipeType = .vertical
    
    let colors: [UIColor] = [.black, .blue, .brown, .orange, .yellow, .magenta, .purple, .green, .gray, .red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardContainer.delegate = self
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardContainer.dataSource = self
    }

    @IBAction func reloadButtonClicked(_ sender: Any) {
        cardContainer.reloadData()
    }
    
    @IBAction func directionButtonClicked(_ sender: Any) {
        if swipeDirection == .vertical {
            swipeDirection = .horizontal
        } else {
            swipeDirection = .vertical
        }
        
        cardContainer.reloadData()
    }
    
    func setUpUI() {
        cardContainer.backgroundColor = .clear
        reloadButton.layer.cornerRadius = 12
        directionButton.layer.cornerRadius = 12
    }
}

extension ViewController: CardContainerDataSource {
    func numberOfCardsToShow() -> Int {
        return colors.count
    }
    
    func card(at index: Int) -> SwipeableView {
        let card = SwipeableView()
        card.layer.cornerRadius = 27
        card.backgroundColor = colors[index]
        return card
    }
    
    func swipeType() -> SwipeType {
        return swipeDirection
    }

}

extension ViewController: CardContainerDelegate {
    func card(_ view: SwipeableView, swiped direction: SwipeDirection) {
        if let color = view.backgroundColor {
            print("\(color) card swiped \(direction)")
        }
    }
    
    func cardContainer(didSelect view: SwipeableView, at index: Int) {
        print("Card at index \(index) was selected")
    }
    
    func cardContainer(willDisplay view: SwipeableView, at index: Int) {
        print("Card container will display card at index: \(index)")
    }
    
    func card(_ view: SwipeableView, swiped direction: SwipeDirection, at index: Int) {
        print("\(index)th card swiped \(direction)")
    }
}
