//
//  TextField.h
//  Uptime
//
//  Created by Minjie Xu on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextField : NSObject

@property (nonatomic, strong) NSString *text;         // The contentView - default is nil
@property (nonatomic) BOOL editable; 
@property (nonatomic) BOOL blackBackground;

@end
