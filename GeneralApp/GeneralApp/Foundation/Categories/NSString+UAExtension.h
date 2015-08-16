//
//  NSString+UAExtension.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (UAExtension)

// URLEncode
- (NSString *)URLEncodedString;

// URLDecode
- (NSString *)URLDecodedString;

// MD5 value
- (NSString *)MD5String;

// JSON value
- (NSDictionary *)JSONValue;

/* 3DES Encryption & decryption
 * @params key: 密钥
 * @params isEncryption: YES加密，NO解密
 * 返回加密后的字符串
 */
-(NSString*)string3DESWithkey:(NSString*)key initVector:(NSString*)initVector encryption:(BOOL)isEncryption;

// DES Encryption
-(NSString*)stringDESWithkey:(NSString*)key encryption:(BOOL)isEncryption;

// NSDate
- (NSDate *)dateWithFormat:(NSString *)format;

// Email check
- (BOOL)isEmailFormat;

// Mobile check
- (BOOL)isMobileFormat;

// Number check
- (BOOL)isNumberFormat;

// Hex to NSString
+ (NSString *)stringWithHex:(u_char *)buffer length:(int)length;

// NSString to hex
- (const char *)hexString;

// Hex color value to UIColor
+ (UIColor *)colorWithHex:(NSString *)hexColor;

@end