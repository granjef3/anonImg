//
//  imgData.m
//  AnonImg
//
//  Created by iD Student on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "imgData.h"

@implementation imgData

- (id)initWithTitle:(NSString*)titleStr imageDat:(UIImage *)imageDat tagsAr:(NSArray *)tagsAr
{   
    if ((self = [super init])) {
        tags = tagsAr;
        title = titleStr;
        image = imageDat;   
    }
    return self;
}

@end
