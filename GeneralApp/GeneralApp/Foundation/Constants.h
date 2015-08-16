//
//  Constants.h
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#ifndef UniversalApp_Constants_h
#define UniversalApp_Constants_h
#import <CoreGraphics/CoreGraphics.h>

/**
 * Data structs
 */

typedef struct
{
    CGFloat max;
    CGFloat min;
} CGRange;

CG_INLINE CGRange CGRangeMake(CGFloat min, CGFloat max)
{
    CGRange range;
    range.min = min;
    range.max = max;
    
    return range;
}

/**
 * App Universal
 */

// Key window
#define getKeyWindow()  [[UIApplication sharedApplication]keyWindow]

// AppDelegate window
#define getAppWindow()  [[[UIApplication sharedApplication]delegate]window]

// Load resources
#define loadNibName(name) [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] lastObject];
#define registerCellNib(tableView, name, identifier) [tableView registerNib:[UINib nibWithNibName:name bundle:nil]forCellReuseIdentifier:identifier]

// ARC judgement
#define definedArcMode()  __has_feature(objc_arc)

// Output debug string
#define OutputCurrentDebugInfo() NSLog(@"\n*********************************\nDebug information:\nFile: %s\nLine: %d\nMethod: [%@ %@]\n*********************************",__FILE__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// Output method string
#define OutputCurrentMethodInfo() NSLog(@"\n*********************************\n> [%@ %@] action.\n*********************************", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// Version
#define OSVersionString() [[UIDevice currentDevice]systemVersion]
#define OSVersionFloat()  [[[UIDevice currentDevice]systemVersion] floatValue]

#define AppVersionString()  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppVersionFloat()   [AppVersionString() floatValue]

// Base configure
#define statusHeight()    20
#define naviHeight()      50
#define tabHeight()       50

#define naviButtonX()      10
#define naviButtonY()      5
#define naviButtonWidth()  40
#define naviButtonHeight() 40

// Font
#define systemFont(size) [UIFont systemFontOfSize:size]
#define boldSystemFont(size) [UIFont boldSystemFontOfSize:size]

// Color
#define rgbColor(r,g,b)     [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0f]
#define rgbaColor(r,g,b,a)  [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

// System color
#define sysBlackColor()       [UIColor blackColor]
#define sysDarkGrayColor()    [UIColor darkGrayColor]
#define sysLightGrayColor()   [UIColor lightGrayColor]
#define sysWhiteColor()       [UIColor whiteColor]
#define sysGrayColor()        [UIColor grayColor]
#define sysRedColor()         [UIColor redColor]
#define sysGreenColor()       [UIColor greenColor]
#define sysBlueColor()        [UIColor blueColor]
#define sysCyanColor()        [UIColor cyanColor]
#define sysYellowColor()      [UIColor yellowColor]
#define sysMagentaColor()     [UIColor magentaColor]
#define sysOrangeColor()      [UIColor orangeColor]
#define sysPurpleColor()      [UIColor purpleColor]
#define sysBrownColor()       [UIColor brownColor]
#define sysClearColor()       [UIColor clearColor]

// Rect
#define rectMake(x, y, w, h)  CGRectMake(x, y, w, h)
#define sizeMake(w, h)        CGSizeMake(w, h)
#define pointMake(x, y)       CGPointMake(x, y)
#define edgeMake(top, left, bottom, right)    UIEdgeInsetsMake(top, left, bottom, right)

// Screen
#define screenWidth() [UIScreen mainScreen].bounds.size.width
#define screenHeight() [UIScreen mainScreen].bounds.size.height
#define screenBounds() [UIScreen mainScreen].bounds
#define screenSize() [UIScreen mainScreen].bounds.size

// Class check
#define checkClass(object, classType) [object isKindOfClass:[classType class]]

// Version check
// Result: NSOrderedSame, NSOrderedAscending, NSOrderedDescending
#define checkVersion(ver1, ver2) [ver1 compare:v2 options:NSNumericSearch]

// Block
#define runOnMainBlock(block) dispatch_async(dispatch_get_main_queue(), block)

// Singleton
#define singletonClass(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname { @synchronized(self) { if (shared##classname == nil) { shared##classname = [[self alloc] init]; } } return shared##classname; } \
+ (id)allocWithZone:(NSZone *)zone { @synchronized(self) {  if (shared##classname == nil) { shared##classname = [super allocWithZone:zone]; return shared##classname; } } return nil; } \
- (id)copyWithZone:(NSZone *)zone { return self; }

/**
 * App data
 */

// User defaults
#define setUserDefaults(key, object) [[NSUserDefaults standardUserDefaults]setObject:object forKey:key]
#define saveUserDefaults()  [[NSUserDefaults standardUserDefaults]synchronize]
#define getUserDefaults(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]

// First launch
#define isAppFirstLaunching()    [getUserDefaults(@"app_firstlaunch") boolValue]?NO:YES
#define setAppFirstLaunched()    setUserDefaults(@"app_firstlaunch",@"YES"), saveUserDefaults()

// Notification
#define NotificationDefaultCenter [NSNotificationCenter defaultCenter]

#define USER_LOGINSUCCESS           @"USER_LOGINSUCCESS"
#define USER_LOGOUTSUCCESS          @"USER_LOGOUTSUCCESS"
#define USER_UPDATENICK             @"USER_UPDATENICK"
#define HOME_NEEDS_REFRESH          @"HOME_NEEDS_REFRESH"
#define FIND_NEW_DEVICE             @"FIND_NEW_DEVICE"
#define READ_SUBDEVICE_LIST         @"READ_SUBDEVICE_LIST"
#define READ_SUBDEVICE_DATA         @"READ_SUBDEVICE_DATA"
#define READ_PLOT_DATA              @"READ_PLOT_DATA"
#define WRITE_PLOT_DATA             @"WRITE_PLOT_DATA"
#define DELETE_PLOT_DATA            @"DELETE_PLOT_DATA"
#define GROUP_NEEDS_UPDATE          @"GROUP_NEEDS_UPDATE"
#define GATEWAY_CHANGE              @"GATEWAY_CHANGE"
#define GROUP_DEV_UPDATE            @"GROUP_DEV_UPDATE"
#define WRITE_DEV_CALLBACK          @"WRITE_DEV_CALLBACK"
#define SINGLEDEV_CALLBACK          @"SINGLEDEV_CALLBACK"
#define GROUPDEV_CALLBACK           @"GROUPDEV_CALLBACK"
#define READ_DEVICE_STATUS          @"READ_DEVICE_STATUS"

// Image
#define loadImage(name)      [UIImage imageNamed:name]
#define loadImageData(data)  [UIImage imageWithData:data]
#define loadImageFile(file)  [UIImage imageWithContentsOfFile:file]

// Path
#define currentDocumentsPath() NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

// Cache path
#define cacheDirectoryPath() [currentDocumentsPath() stringByAppendingPathComponent:@"CachesDirectory"];

// Network message
#define NETWORK_RELOAD @"点击重新加载"

// For app custom
#define LIB_HEART_REMOTE   600
#define LIB_HEART_LOCAL    60
#define LIB_SERVER         "i.10000bee.com" // "115.28.39.192"

// For app encode
#define APP_SERVER         @"http://i.10000bee.com"
#define APP_KEY            @"sd7832ehdwekwp9e"
#define APP_SECRET         @"my3871ehdwekwp9e"

// HUD
#define showWithStatus(text)           (OSVersionFloat() < 7.0)?[ProgressHUD showWithStatus:text]:[ProgressHUD showLWithStatus:text]
#define showSuccessWithStatus(text)    (OSVersionFloat() < 7.0)?[ProgressHUD showSuccessWithStatus:text]:[ProgressHUD showLSuccessWithStatus:text]
#define showErrorWithStatus(text)      (OSVersionFloat() < 7.0)?[ProgressHUD showErrorWithStatus:text]:[ProgressHUD showLErrorWithStatus:text]
#define dismiss()                      [ProgressHUD dismiss]

// GCD
#define global_queue()      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define main_queue()        dispatch_get_main_queue()
#define current_queue()     dispatch_get_current_queue()

#endif
