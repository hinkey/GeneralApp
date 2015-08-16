//
//  UITableView+UAExtension.m
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import "UITableView+UAExtension.h"

@implementation UITableView (UAExtension)

+ (id)groupedWithFrame:(CGRect)frame
{
    return [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
}

+ (id)plainWithFrame:(CGRect)frame
{
    return [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
}

@end
