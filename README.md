# SwiftyJSONFetch

[![CI Status](https://img.shields.io/travis/Thomas Marien/SwiftyJSONFetch.svg?style=flat)](https://travis-ci.org/Thomas Marien/SwiftyJSONFetch)
[![Version](https://img.shields.io/cocoapods/v/SwiftyJSONFetch.svg?style=flat)](https://cocoapods.org/pods/SwiftyJSONFetch)
[![License](https://img.shields.io/cocoapods/l/SwiftyJSONFetch.svg?style=flat)](https://cocoapods.org/pods/SwiftyJSONFetch)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyJSONFetch.svg?style=flat)](https://cocoapods.org/pods/SwiftyJSONFetch)

## Description

Due to the amount of coding challenges for new jobs, where 99% are about loading JSON from somewhere, I decided to implement my own solution instead of using Alamofire (which is indeed awesome) or another library. That helped me refreshing my knowledge and in the end I learned something new. I also decided to make it public so you guys can learn or even make it better. Feel free to contribute! Bring in your ideas!

## Disclaimer
Although I invested some time implementing the code and testing it, it is not considerred as complete. There are some pieces missing which I will add over the time.

## Features
* Load JSON from URL
* Load JSON from given file in Bundle
* Automatically decode to a given Model conforming to the Codable protocol

## Installation

SwiftyJSONFetch is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyJSONFetch'
```

## Usage
#### tl;dr
Using it is pretty simple. Just call:
```swift
SwiftyJSONFetch().fetch(fromURLString: "http://some.url/json", forType: MyModel.self) { (response, error) in
    //Do stuff
}
```
or if you want to fetch something from a file:
```swift
SwiftyJSONFetch().fetch(fromFileName: "someJSONFile", forType: MyModel.self) { (response, error) in
    //Do stuff
}
```

#### The long version: from URL
SwiftyJSONFetch can be configured by chaining several methods to one call. Simply call it like this:
```swift
SwiftyJSONFetch()
    .body(body) //some body of type Data
    .header(["Content-Type":"application/json"])
    .parameters(["key1":"value1"])
    .method(.post)
    .fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
    //Do stuff
}
```
You are not limitted to use all of those methods. You could only use `SwiftyJSONFetch().header(["Content-Type":"application/json"]).fetch...` if you just want to set a header for example.

#### The long version: from File
If you just want to load some JSON from a file you don't have to configure something special. You can inject a Bundle if you want, but that's it. I used it for my Unit Tests but you can use it to load from a Bundle other than `Bundle.main`.

## FAQ
**Why don't you just use Alamofire?**
Alamofire does a great job and I use it where it is reasonable. This project was born because of the amount of coding challenges I had to fulfill in order to apply to a job. Using third party libraries is ok so far but I wanted to do it by myself.

**If you don't want to use third party libraries, why a pod then?**
Because I implemented it by myself. So it is not third party but my very own implementation. I also wanted to share it with you so you can play around with it!

**Are more features comming?**
I hope so. But it will be limited as there are other solutions out there which do the job right. I think it's more about improvements and a way to learn how it works.

**Can I contribute?**
For sure! Just make a Pull request and we will see what will happen.

**May I ask you something?**
Yes, just drop me a message!

## Author

Thomas Marien, titatomte@gmail.com

## License

SwiftyJSONFetch is available under the MIT license. See the LICENSE file for more info.

