# SecondHand
> SecondHand is a market place app which allow users to browse and post announces for objects they would like to buy or sell second hand.
> Live demo [https://youtu.be/9y-Gfg2z9JA]

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Setup](#setup)
* [Usage](#usage)
* [Project Status](#project-status)
* [Room for Improvement](#room-for-improvement)
* [Contact](#contact)
<!-- * [License](#license) -->


## General Information
- The app let users browse announces posted by other users, add them to their favourite, contact users via a real time chat and post their own announces.
- SecondHand is developed using SWIFT UI, and firebase for the backend. 15+ screens
- Followed clean architecture principles, with separation of concerns, dependency injections via Protocols and MVVM pattern. Units tests also available
- Extensive use of asynchronus functions with async/await, combine and callbacks.
- I have developed this app in order to put into application what I have learnt from classes at the Apple Developer Academy (only Apple academy in Europe), and online tutorials (100 days with swift UI, Stanford CSP193)


## Technologies Used
- Backend: Firebase Firestore and Firebase Storage for images
- Swift UI
- async/await, Combine
- 3rd party frameworks: Swinject for dependency injection, NukeUI for async loading/display of images, Quick/Nimble for unit tests,  GoogleSignIn, FacebookSignIn

## Features
- Infinite scroll view with pagination, and pull to refresh announces, and async loading of images
- Log in with Google, Facebook or email
- Create you own announce
- Manage your favourites
- Real time chat with many different users regarding their announces or the one you created. Automatic scroll to most recent message and show unread messages count
- Create/update your user profile
- import photo from library or camera
- Filtering of announces
- various animations used throughout the project


## Screenshots
<img src="https://user-images.githubusercontent.com/114009067/206210960-71675dcc-5068-4211-8d11-db80b968b329.png" width="325"/> <img src="https://user-images.githubusercontent.com/114009067/206210700-2f37a4e9-1739-46bb-b98b-92c46d57495e.png" width="325"/> <img src="https://user-images.githubusercontent.com/114009067/206213312-b13e164e-9269-44aa-b518-58970d9a6ec4.png" width="325"/>
<img src="https://user-images.githubusercontent.com/114009067/206213901-87ffd1ce-e21e-4618-91af-f5cfa9d01ddc.png" width="325"/> <img src="https://user-images.githubusercontent.com/114009067/206216250-e2942f7e-94e7-4021-90de-22f65a4ef13c.png" width="325"/> <img src="https://user-images.githubusercontent.com/114009067/206216758-f47cc0a8-6e00-4d64-8b78-075c393907f4.png" width="325"/>



## Setup
- When cloning the repo xcode will automatically open the .xcodeproj file, please close and open the xcworkspace file in the same folder.
- Although most dependencies have been installed using Swift package manager, Quick & Nimble only work when installed via CocoaPod at the moment hence why the xcworkspace file should be used.


## Usage
Hopefully everything should be fairly intuitive and work as you expect a market place app to work.
- Click on category image in homepageView to get announces filtered by category, or click on searchbar to have more filters available
- Click on heart top right of images to add/remove from favourite.
- Swipe an image to display another one if available for this announce
- Click on announce for detailed view
- Click on Message button at the bottom to start a chat with the user who posted the announce.

- Refer to the video for more, link at the top of the page


## Project Status
This project is fairly big and many more features are needed to make it a fully fledge market place, like the ability to pay etc. But I feel the project is big enough to be used as a platform to showcase my skills and have meaningful conversation with companies and recruiter. 


## Room for Improvement
- I am currently going through unit testing but the unit tests will definitely not cover the whole project as it takes too much time. 
- But I do feel there are enough unit testing done at the moment to show my understanding in creating mock classes and injecting them in the system under stress in order to test different scenarios.
- The current unit tests cover asynchronus function with async/await and use combine to test publishers are updated and publish as expected.

## Contact
Created by Benjamin SZAKAL, benjamin.szakal1@gmail.com - feel free to contact me!
