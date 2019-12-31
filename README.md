# AssetManagementApp
Intended for internal use by the IT team at the Herberger Institute of Design and the Arts. This application is used for tracking inventory counts and keeping track of assets either borrowed or assigned by/to members of ASU faculity and staff. This app was built to improve on  Herberger IT’s tracking of consumables in one location. 

## Getting Started
iOS 13.3 or higher is required to run this application

## Built With
* [Swift 5](https://swift.org/blog/swift-5-released/)
* [XCode11.3](https://developer.apple.com/documentation/xcode_release_notes/xcode_11_3_release_notes)
* [Firebase 6.13.0](https://firebase.google.com/support/release-notes/ios#6.13.0-patch)
* [CocoaPods](https://cocoapods.org/)

## Basic Overview
This app has three different functions
1. Loaned Consumables
2. Assigned Consumables
3. In Stock Consumables

### Loaned Consumables
This part of the app is where people who are only temporarily using a piece of equipment. You can sort the list using a variety of properties or directly search for someone. The return date will show up on the right side of the table. When the date is red it is past its original return date and the user needs to be reached out to. Tapping on the item in the row will open up anew page with additional information. Swiping to the left will delete the item essentially meaning the item has been returned. By checking out or returning the item the overall count will decrease throughout the app. 

When hitting the plus button in this section you will be presented a check out page. Fill out the required information and have the user sign for the item. This will ensure that they will accept responsibility for the item they are taking. It is worth noting that the adapter type will be automatically generated from In Stock Consumables. More on this later.

### Assigned Consumables 
Not to be confused with Loaned consumables this option is exists for people that are given a required item by Herberger IT. This mainly effects people receiving new MacBooks Pros. The features of this page are similar to the Loaned Consumables page. However, we don’t have a signature field as we assign them the consumables. The same search features are avaliable as in the Loaned Consumables section

## Authors
* [Meghan Woodford](https://github.com/mmwoodfo)
* [ImAnthony](https://github.com/ImAnthony)
