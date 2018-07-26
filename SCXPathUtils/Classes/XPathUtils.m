//
//  XPathUtils.m
//  sma11caseSDK
//
//  Created by sma11case on 02/04/2018.
//  Copyright © 2018 sma11case. All rights reserved.
//

#import "XPathUtils.h"

#define UseXPathDebugCode 0
#define sc_mlog(...)
#define BreakPointHere

#pragma mark Core Functions

id sc_xpathGet(id object, NSString *xpath, NSString *sep)
{
    if ([xpath hasPrefix:sep]) xpath = [xpath substringFromIndex:sep.length];
    if (0 == xpath.length) return nil;
    
    typedef id(^TempBlock)(id object, NSString *key);
    TempBlock b1 = ^id(id obj2, NSString *key){
        
        if ([obj2 isKindOfClass:[NSArray class]])
        {
            BreakPointHere;
            return (id)[obj2 objectAtIndex:key.integerValue];
        }
        
        if ([obj2 isKindOfClass:[NSDictionary class]])
        {
            BreakPointHere;
            return (id)[obj2 objectForKey:key];
        }
        
        BreakPointHere;
        return nil;
    };
    
    __block id res = object;
    NSArray *temp = [xpath componentsSeparatedByString:sep];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        res = b1(res, obj);
    }];
    return res;
}

BOOL sc_xpathSet(id object, NSString *xpath, NSString *sep, SCXPathNewObjectBlock block)
{
#if UseXPathDebugCode
    {
        id obj = ^(id root_object, NSString *dest_xpath, id op_object, NSString *current_xpath){
            id res = block(root_object, dest_xpath, op_object, current_xpath);
            sc_mlog(@"sc_xpathSet: %@ ==> %@ value: %@", dest_xpath, current_xpath, [res class]);
            return res;
        };
        block = obj;
    }
#endif
    
    if ([xpath hasPrefix:sep]) xpath = [xpath substringFromIndex:sep.length];
    if (0 == xpath.length) return NO;
    
    NSArray *temp = [xpath componentsSeparatedByString:sep];
    
    __block BOOL res = NO;
    {
        id obj = ^(id root_object, NSString *dest_xpath, id op_object, NSString *current_xpath){
            res = [dest_xpath isEqualToString:current_xpath];
            return block(root_object, dest_xpath, op_object, current_xpath);
        };
        block = obj;
    }
    
    __block id target = object;
    [temp enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (nil == target)
        {
            *stop = YES;
            BreakPointHere;
            return ;
        }
        
        const id(^b1)() = ^{
            NSMutableString *xpath2 = NewMutableString();
            for (long a = 0; a < idx; ++a)
            {
                [xpath2 appendString:temp[a]];
                [xpath2 appendString:sep];
                BreakPointHere;
            }
            return xpath2;
        };
        
        if ([target isKindOfClass:[NSArray class]])
        {
            NSMutableArray *aaa = target;
            
            CopyOnlyConst(key.integerValue, index);
            
            long x = 0;
            while ((x = aaa.count) < index)
            {
                NSMutableString *xpath2 = b1();
                [xpath2 appendFormat:@"%zd", x];
                
                id obj = block(object, xpath, aaa, xpath2);
                if (obj) [aaa addObject:obj];
                else
                {
                    target = nil;
                    *stop = YES;
                    return;
                }
            }
            
            if (index >= aaa.count || temp.lastObject == key)
            {
                NSMutableString *xpath2 = b1();
                [xpath2 appendFormat:@"%zd", index];
                
                id obj = block(object, xpath, aaa, xpath2);
                if (obj) aaa[index] = obj;
                else if (aaa.count > index) [aaa removeObjectAtIndex:index];
            }
            
            target = (aaa.count > index ? aaa[index] : nil);
            BreakPointHere;
            return ;
        }
        
        if ([target isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary *aaa = target;
            
            if (nil == aaa[key] || temp.lastObject == key)
            {
                NSMutableString *xpath2 = b1();
                [xpath2 appendString:key];
                
                id obj = block(object, xpath, aaa, xpath2);
                if (obj) aaa[key] = obj;
                else [aaa removeObjectForKey:key];
            }
            
            target = aaa[key];
            BreakPointHere;
            return ;
        }
        BreakPointHere;
    }];
    
    sc_mlog(@"sc_xpathSet: %@ ==> %s", xpath, (res?"YES":"NO"));
    return res;
}

#pragma mark Default Delimiter

static NSString *kXpathDelimiter = @"/";

void sc_xpathSetDelimiter(NSString *sep)
{
    kXpathDelimiter = sep;
    BreakPointHere;
}

#pragma mark XPath Reader

@implementation NSArray(sma11case_XPath)

- (SCXPathObjectBlock)xObject
{
    return ^id(NSString *xpath){
        return sc_xpathGet(self, xpath, kXpathDelimiter);
    };
}

- (SCXPathStringBlock)xString
{
    return [self xObject];
}

- (SCXPathNumberBlock)xNumber
{
    return [self xObject];
}

- (SCXPathArrayBlock)xArray
{
    return [self xObject];
}

- (SCXPathDictionaryBlock)xDictionary
{
    return [self xObject];
}

- (BOOL)setXPath: (NSString *)xpath block: (SCXPathNewObjectBlock)block{return NO;}
@end

@implementation NSDictionary(sma11case_XPath)

- (SCXPathObjectBlock)xObject
{
    return ^id(NSString *xpath){
        return sc_xpathGet(self, xpath, kXpathDelimiter);
    };
}

- (SCXPathStringBlock)xString
{
    return [self xObject];
}

- (SCXPathNumberBlock)xNumber
{
    return [self xObject];
}

- (SCXPathArrayBlock)xArray
{
    return [self xObject];
}

- (SCXPathDictionaryBlock)xDictionary
{
    return [self xObject];
}

- (BOOL)setXPath: (NSString *)xpath block: (SCXPathNewObjectBlock)block{return NO;}
@end

#pragma mark XPath Writter

@implementation NSMutableArray(sma11case_XPath)
- (BOOL)setXPath: (NSString *)xpath block: (SCXPathNewObjectBlock)block
{
    return sc_xpathSet(self, xpath, kXpathDelimiter, block);
}
@end

@implementation NSMutableDictionary(sma11case_XPath)
- (BOOL)setXPath: (NSString *)xpath block: (SCXPathNewObjectBlock)block
{
    return sc_xpathSet(self, xpath, kXpathDelimiter, block);
}
@end
