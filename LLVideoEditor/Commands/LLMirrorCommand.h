//
//  LLMirrorCommand.h
//  LLVideoEditorExample
//
//  Created by Daria Kovalenko on 10/16/15.
//  Copyright © 2015 Ömer Faruk Gül. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLVideoEditor.h"
#import "LLVideoData.h"

@interface LLMirrorCommand : NSObject <LLCommandProtocol>
// disable the basic initializer
- (instancetype)init NS_UNAVAILABLE;
// default initializer
- (instancetype)initWithVideoData:(LLVideoData *)videoData needRotate:(BOOL)needRotate;
@end
