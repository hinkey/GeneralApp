//  NSDictionary+UAExtension.m
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import "NSDictionary+UAExtension.h"

@implementation NSDictionary (UAExtension)

- (NSString *)JSONString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return json;
    
}

@end
