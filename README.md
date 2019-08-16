# CardContainer

**If you like CardContainer, give it a ⭐**



## Overview

CardContainer is a simple Tinder-like card cosntainer with `UITableView`-like API.

|                  Vertical swiping                  |                   HorizontalSwiping                   |
| :------------------------------------------------: | :---------------------------------------------------: |
| ![Vertical swiping](./Screenshots/CardExmaple.gif) | ![Horizontal swiping](./Screenshots/CardExample1.gif) |





## Installation

### Manual installation

Put all files from `CardExample/CardContainer` folder into your project



### Carthage

*Soon...*



## Usage

1. Place a `view`  and change its class to `CardContainer`

   ![image-20190805173006508](./Screenshots/CardExample2.png)

2. Implement `CardContainerDataSource` in your Controller (check the example project).

3. Make your Controller a delegate of `CardContainer` view (check the example project).

## Customisation

### SwipeableView

```swift
// Vertical threshold for swiping a view (in percents of view's height)
// Is applicable only when the SwipeType is vertical
var verticalThreshold: CGFloat

// Horizontal threshold for swiping a view (in percents of view's width)
// Is applicable only when the SwipeType is horizontal
var horizontalThreshold: CGFloat
```

### CardContainer

```swift
// Number of cards visible in a container
var cardsToBeVisible: Int

// Horizontal inset of a card in a container
var horizontalInset: CGFloat

// Vertical inset of a card in a container
var verticalInset: CGFloat
```

### CardContainerDatasource

```swift
// Defines the number of cards to be shown
func numberOfCardsToShow() -> Int

//Returns the card for a specified index
func card(at index: Int) -> SwipeableView

//Defines a swipe type in the container
func swipeType() -> SwipeType
```

### CardContainerDelegate

```swift
// Tells the delegate that the view was swiped
func card(_ view: SwipeableView, swiped direction: SwipeDirection)

// Tells the delegate that the view at the specified index was swiped
func card(_ view: SwipeableView, swiped direction: SwipeDirection, at index: Int)

// This method is called when the view is about to appear in the bottom of the card stack.
func cardContainer(willDisplay view: SwipeableView, at index: Int)

//innerIndex is index in visible card stack. This method is called when the view is about to appear in the bottom of the card stack.
func cardContainer(willDisplay view: SwipeableView, with innerIndex: Int)

// Tells the delegate that the specified view is selected
func cardContainer(didSelect view: SwipeableView, at index: Int)
```

### Providing custom views

To provide your own cards to `CardContainer` you have to subclass `SwipeableView` .

*e.g. [Creating a Custom View From a XIB](https://medium.com/better-programming/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960)*



## License

CardContainer is available under the MIT license.