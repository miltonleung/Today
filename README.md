# Today-ios

<a href="https://zenhub.io"><img src="https://raw.githubusercontent.com/ZenHubIO/support/master/zenhub-badge.png" height="18px"></a>
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=BUDDYBUILD-APP-ID&branch=staging&build=latest)](https://dashboard.buddybuild.com/apps/BUDDYBUILD-APP-ID/build/latest?branch=staging)

# Today iOS

## Description
Description of your project.

## Repos
- General: [https://github.com/axiomzen/project](https://github.com/axiomzen/project)
- iOS: [https://github.com/axiomzen/project-ios](https://github.com/axiomzen/project-ios)
- API: [https://github.com/axiomzen/project-api](https://github.com/axiomzen/project-api)

## Build Requirements
+ Xcode 8.3.1
+ iOS 10.0 SDK or later
+ CocoaPods 1.2.0

## How to run the project
1. Download [CocoaPods](https://cocoapods.org/)
2. Go to `/Today` and run `pod update`
3. Open `Today.xcworkspace`. **NOT `Today.xcodeproj`**

### Running it on your iOS device

_Note: Your device needs to be connected to our iOS Dev Center. If it's not (i.e. it's your first time running an Axiom Zen Xcode project on your device), please ask an iOS Folk to help you set it up._

1. Download [fastlane](https://github.com/fastlane/fastlane)
2. Go to `/Today` in your console
3. Run `fastlane certs`
4. Select your iOS device in Xcode and hit run.