#import "NSString+UAExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Base64.h"

@implementation NSString (UAExtension)

- (NSString *)URLEncodedString
{
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (CFStringRef)self,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                    kCFStringEncodingUTF8);
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    CFSTR(""),
                                                                                                    kCFStringEncodingUTF8);
    return result;
}

- (NSString *)MD5String
{
    const char *original_str = [self UTF8String];
    u_char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSDictionary *)JSONValue
{
    NSDictionary *retData = nil;
    NSError *error = nil;
    
    @try {
        NSData *responseData = [self dataUsingEncoding:NSUTF8StringEncoding];
        retData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"NSDictionay -> NSString exception:%@",exception.description);
        return retData;
    }
    @finally {
        if (error) {
            NSLog(@"NSDictionay -> NSString exception:%@",error.description);
        }
        return retData;
    }
}

-(NSString*)string3DESWithkey:(NSString*)key initVector:(NSString*)initVector encryption:(BOOL)isEncryption
{
    CCOperation operation = isEncryption?kCCEncrypt:kCCDecrypt;
    return [self string3DESWithkey:key initVector:initVector operation:operation];
}

// 3DES Encryption & decryption
-(NSString*)string3DESWithkey:(NSString*)key initVector:(NSString*)initVector operation:(CCOperation)operation
{
    const void * vplainText;
    size_t plainTextBufferSize;
    
    if (operation== kCCDecrypt) {
        NSData * encryptData = [NSData dataFromBase64String:self];
        plainTextBufferSize = [encryptData length];
        vplainText = [encryptData bytes];
    } else {
        NSData * tempData = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize= [tempData length];
        vplainText = [tempData bytes];
        
    }
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES)&~(kCCBlockSize3DES- 1);
    
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    
    NSString * initVec = initVector;
    
    const void * vkey= (const void *)[key UTF8String];
    const void * vinitVec= (const void *)[initVec UTF8String];
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void*) iv,0x0, (size_t)sizeof(iv));
    
    ccStatus = CCCrypt(operation,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void*)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) {
        NSString * result;
        if (operation== kCCDecrypt) {
            result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
        } else {
            NSData * retData =[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
            result = [retData base64EncodedString];
        }
        
        return result;
    }
    
    return nil;
}

-(NSString*)stringDESWithkey:(NSString*)key encryption:(BOOL)isEncryption
{
    CCOperation operation = isEncryption?kCCEncrypt:kCCDecrypt;
    return [self stringDESWithkey:key operation:operation];
}

- (NSString*)stringDESWithkey:(NSString*)key operation:(CCOperation)operation
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset((void*)buffer,0x0, bufferSize);
    
    size_t numBytes = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytes);
    if (cryptStatus == kCCSuccess) {
        NSString *retString = nil;
        if (operation == kCCEncrypt) {
            NSData *retData = [NSData dataWithBytesNoCopy:buffer length:numBytes];
            retString = [[retData base64EncodedString]URLEncodedString];
        } else {
            retString = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytes] encoding:NSUTF8StringEncoding];
        }
        
        return retString;
    }
    
    return nil;
}

- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

// Email check
- (BOOL)isEmailFormat
{
    if (self && self.length > 3) {
        NSArray *array = [self componentsSeparatedByString:@"."];
        if ([array count] >= 4) {
            return NO;
        }
        
        NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [predicate evaluateWithObject:self];
    }
    
    return NO;
}

// Mobile check
- (BOOL)isMobileFormat
{
    if (self && self.length == 11) {
        return [self isNumberFormat];
    }
    
    return NO;
}

// Number check
- (BOOL)isNumberFormat
{
    const char *cvalue = [self UTF8String];
    size_t clen = strlen(cvalue);
    for (size_t i = 0; i < clen; i ++) {
        if (!isdigit(cvalue[i])) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)stringWithHex:(u_char *)buffer length:(int)length
{
    if (buffer == NULL) {
        return nil;
    }
    
    char *_buffer =(char *)malloc(length * 2 + 1);
    memset(_buffer, 0, length * 2 + 1);
    
    for(int i = 0; i < length; i++) {
        u_char temp = buffer[i];
        if((temp >> 4) < 10) {
            _buffer[i*2]= '0' + (temp >> 4);
        } else {
            _buffer[i*2] = 'A' + (temp >> 4) - 10;
        }
        
        if((temp & 0x0F) < 10) {
            _buffer[i * 2 + 1] = '0' + (temp & 0x0F);
        } else {
            _buffer[i * 2 + 1] = 'A' + (temp & 0x0F) - 10;
        }
    }
    
    _buffer[length * 2] = '\0';
    
    NSString *retString =[[NSString alloc] initWithUTF8String:(const char *)_buffer];
    
    free(_buffer);
    _buffer = NULL;
    
    return retString;
}

- (const char *)hexString
{
    NSInteger length = 0;
    const char *utf8 = [self UTF8String];
    u_char *buffer = (u_char *)malloc(sizeof(u_char) * self.length / 2 + 1);
    memset(buffer, 0, self.length / 2 + 1);
    
    for(NSInteger i = 0; i < self.length; i += 2) {
        u_char high = (u_char)utf8[i];
        u_char low = (u_char)utf8[i + 1];
        
        if (high >= 'A' && high <= 'F') {
            high = high - 'A' + 0x0A;
        } else if (high >= 'a' && high <= 'f') {
            high = high - 'a' + 0x0A;
        } else {
            high = high - '0';
        }
        
        if (low >= 'A' && low <= 'F') {
            low = low - 'A' + 0x0A;
        } else if (low >= 'a' && low <= 'f') {
            low = low - 'a' + 0x0A;
        } else {
            low = low - '0';
        }
        
        buffer[length ++] = (low | ((high << 4) & 0xF0));
    }
    buffer[length] = '\0';
    
    return (const char *)buffer;
}

+ (UIColor *)colorWithHex:(NSString *)hexColor
{
    if (hexColor && hexColor.length > 0) {
        if ([hexColor rangeOfString:@"#"].location == 0) {
            hexColor = [hexColor substringFromIndex:1];
        }
        
        int high = 0, low = 0, rvalue = 0, gvalue = 0, bvalue = 0;
        if (hexColor.length >= 6) {
            const char *value = [[hexColor lowercaseString] UTF8String];
            for (int i = 0; i < 6; i ++) {
                char cvalue = value[i];
                if (cvalue > '9') {
                    cvalue = cvalue - 'a' + 10;
                } else {
                    cvalue = cvalue - '0';
                }
                
                if (i % 2 == 0) {
                    high = cvalue;
                } else {
                    low = cvalue;
                }
                
                if (i % 2 == 1) {
                    if (i / 2 == 0) {
                        // red
                        rvalue = high * 16 + low;
                    } else if (i / 2 == 1) {
                        // green
                        gvalue = high * 16 + low;
                    } else if (i / 2 == 2) {
                        // blue
                        bvalue = high * 16 + low;
                    }
                }
            }
        }
        
        return [UIColor colorWithRed:rvalue / 255.f green:gvalue / 255.f blue:bvalue / 255.f alpha:1.0];
    }
    
    return nil;
}

@end
