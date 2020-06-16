# Skeleton SwiftUI

## How to launch
* pod install
* In the top left corner, you can select 2 different scheme:
    * **SkeletonSwiftUI (dev)**: this build will compile with keys located in SkeletonSwiftUI/Config/Dev.xcconfig
    * **SkeletonSwiftUI (prod)**: this build will compile with keys located in SkeletonSwiftUI/Config/Prod.xcconfig
* Note that if you try to launch these builds on one phone, it will create 2 different apps
* Test User1:
    * email: cyril@test.com
    * mdp: password
* Test User2:
    * email: artista@test.com
    * mdp: password

# How it works

## Config
* Dev.xcconfig: keys used to create the **SkeletonSwiftUI (dev)** build
* Prod.xcconfig: keys used to create the **SkeletonSwiftUI (prod)** build
> **Note:** Add your environment constants and your API Keys here!

> In order to use a key in the Info.plist, you just have to do:
`<key>ROOT_URL</key><string>$(ROOT_URL)</string>`
* Config.swift: Class in order to get keys in Info.plist and config variables in your code

## Utils
* Event.swift: class useful when you want to publish an value only one time with viewModels
> **Note:** Useful when you want to show errors (use example in LoginVM.swift)
## Extension
* SwiftEntryKit.swift: In order to show error or success popups
* String.swift
* Color.swift
> You have a color example in the Assets folder that is taking care of light and dark mode

## Manager
* KeychainManager.swift: Manage iOS Keychain Storage [Pod link](https://github.com/evgenyneu/keychain-swift)
* AppDataManager.swift: Store app's main data

## Views
* UIKit: Put your UIKit components here!

**View structure:**
The project is using an MVVM architecture.
> **TLDR:** Models are defining data's shape, Views only deal with displaying content and ViewModels handle all the business logic.
> If you have done Kotlin or React with Redux, you know what is it

Some links:
* [https://quickbirdstudios.com/blog/swiftui-architecture-redux-mvvm/](https://quickbirdstudios.com/blog/swiftui-architecture-redux-mvvm/)
* [https://nalexn.github.io/clean-architecture-swiftui/](https://nalexn.github.io/clean-architecture-swiftui/)

`@ObservedObject var loginVM: LoginVM`: Use ObservedObject when you want to use your viewModels.
`.onReceive(self.loginVM.$isLoading) { newValue in self._isLoading = newValue }`: Every time that the value `isLoading` is modified by the viewModel, this callback is triggered with the newValue.
> **Note:** Use that pattern to update your views

## ViewModels
* ViewModelInjector.swift: Singleton used to store viewModels that needs to be share across the app. Use this class to provide all the parameters (mostly viewModels) to your views.

>**Note:** You can put your previews with fake data in the extension

## WebService And Models
* Add your DTO in DTO.swift
* Add your API endpoints in WebService.swift
