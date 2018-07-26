//
//  XPathUtils.h
//  sma11caseSDK
//
//  Created by sma11case on 02/04/2018.
//  Copyright © 2018 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^SCXPathObjectBlock)(NSString *xpath);
typedef NSArray *(^SCXPathArrayBlock)(NSString *xpath);
typedef NSDictionary *(^SCXPathDictionaryBlock)(NSString *xpath);
typedef NSString *(^SCXPathStringBlock)(NSString *xpath);
typedef NSNumber *(^SCXPathNumberBlock)(NSString *xpath);
typedef id(^SCXPathNewObjectBlock)(id root_object, NSString *dest_xpath, id op_object, NSString *current_xpath);

extern void sc_xpathSetDelimiter(NSString *sep);
extern id sc_xpathGet(id object, NSString *xpath, NSString *sep);
extern BOOL sc_xpathSet(id object, NSString *xpath, NSString *sep, SCXPathNewObjectBlock block);


@protocol XPathUtilDelegate<NSObject>

@required
@property (nonatomic, strong, readonly) SCXPathArrayBlock xArray;
@property (nonatomic, strong, readonly) SCXPathNumberBlock xNumber;
@property (nonatomic, strong, readonly) SCXPathDictionaryBlock xDictionary;
@property (nonatomic, strong, readonly) SCXPathStringBlock xString;
@property (nonatomic, strong, readonly) SCXPathObjectBlock xObject;

- (BOOL)setXPath: (NSString *)xpath block: (SCXPathNewObjectBlock)block;
@end

@interface NSArray(sma11case_XPath)<XPathUtilDelegate>
@end

@interface NSDictionary(sma11case_XPath)<XPathUtilDelegate>
@end

