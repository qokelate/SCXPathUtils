# SCXPathUtils

[![CI Status](https://img.shields.io/travis/sma11case/SCXPathUtils.svg?style=flat)](https://travis-ci.org/sma11case/SCXPathUtils)
[![Version](https://img.shields.io/cocoapods/v/SCXPathUtils.svg?style=flat)](https://cocoapods.org/pods/SCXPathUtils)
[![License](https://img.shields.io/cocoapods/l/SCXPathUtils.svg?style=flat)](https://cocoapods.org/pods/SCXPathUtils)
[![Platform](https://img.shields.io/cocoapods/p/SCXPathUtils.svg?style=flat)](https://cocoapods.org/pods/SCXPathUtils)

### A simple xpath solution for iOS/macOS.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```

 // set default delimiter, default is "/"
    //    sc_xpathSetDelimiter(@"---");
    
    // create a object to test, maybe Dictionary or Array
    NSMutableDictionary *dds = [@{} mutableCopy];
    
    // set value for node, will prompt for every node if not exists.
    [dds setXPath:@"/root/yyy/3/sss" block:^id(id root_object, NSString *dest_xpath, id current_object, NSString *current_xpath) {
        
        NSLog(@"set value for: %@", current_xpath);
        
        if ([current_xpath hasSuffix:@"root"]) return [@{} mutableCopy];
        if ([current_xpath hasSuffix:@"yyy"]) return [@[] mutableCopy];
        if ([current_xpath hasSuffix:@"0"]) return @100;
        if ([current_xpath hasSuffix:@"1"]) return @"a1";
        if ([current_xpath hasSuffix:@"2"]) return @"a2";
        if ([current_xpath hasSuffix:@"3"]) return [@{} mutableCopy];
        return @"value";
    }];
    
    // just have a look ..........
    NSLog([dds description]);
    
    // read value
    NSLog(@"query1: %zd", dds.xString(@"root/yyy/2").length);
    NSLog(@"query2: %@", dds.xDictionary(@"root/yyy/3"));
    
    // change value for node
    [dds setXPath:@"root/yyy/1" block:^id(id root_object, NSString *dest_xpath, id current_object, NSString *current_xpath) {
        return @6000;
    }];
    
    // look for change
    NSLog([dds description]);
    
    // set nil to remove node
    [dds setXPath:@"root/yyy/3" block:^id(id root_object, NSString *dest_xpath, id current_object, NSString *current_xpath) {
        return nil;
    }];
    
    // look for change
    NSLog([dds description]);
    

```

## Installation

SCXPathUtils is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SCXPathUtils'
```

## Author

sma11case, qokelate@gmail.com

## License

SCXPathUtils is available under the MIT license. See the LICENSE file for more info.
