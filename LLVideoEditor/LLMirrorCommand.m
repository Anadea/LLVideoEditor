//
//  LLMirrorCommand.m
//  LLVideoEditorExample
//
//  Created by Daria Kovalenko on 10/16/15.
//  Copyright © 2015 Ömer Faruk Gül. All rights reserved.
//

#import "LLMirrorCommand.h"
@import AVFoundation;
@interface LLMirrorCommand()
@property (weak, nonatomic) LLVideoData *videoData;
@end
@implementation LLMirrorCommand
- (instancetype)initWithVideoData:(LLVideoData *)videoData {
    self = [super init];
    if(self) {
        _videoData = videoData;
    }
    
    return self;
}

- (void)execute {
    
    CGSize videoSize = self.videoData.videoComposition.renderSize;
    
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoSize.height, 0.0);
    CGAffineTransform t2 = CGAffineTransformScale(t1, -1.0, 1.0);
    videoSize = CGSizeMake(videoSize.height, videoSize.width);
    
    CMTime duration = self.videoData.videoCompositionTrack.timeRange.duration;
    
    if (self.videoData.videoComposition.instructions.count == 0) {
        // The rotate transform is set on a layer instruction
        instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
        
        layerInstruction = [AVMutableVideoCompositionLayerInstruction
                            videoCompositionLayerInstructionWithAssetTrack:self.videoData.videoCompositionTrack];
        [layerInstruction setTransform:t2 atTime:kCMTimeZero];
    }
    else {
        // Extract the existing layer instruction on the mutableVideoComposition
        instruction = (AVMutableVideoCompositionInstruction *)[self.videoData.videoComposition.instructions lastObject];
        layerInstruction = (AVMutableVideoCompositionLayerInstruction *)[instruction.layerInstructions lastObject];
        
        CGAffineTransform existingTransform;
        
        BOOL success = [layerInstruction getTransformRampForTime:duration
                                                  startTransform:&existingTransform
                                                    endTransform:NULL timeRange:NULL];
        
        if (!success) {
            [layerInstruction setTransform:t2 atTime:kCMTimeZero];
        } else {
            //CGAffineTransform t3 = CGAffineTransformMakeTranslation(-1 * videoSize.height / 2, 0.0);
            //CGAffineTransform newTransform = CGAffineTransformConcat(existingTransform, CGAffineTransformConcat(t2, t3));
            //[layerInstruction setTransform:newTransform atTime:kCMTimeZero];
            
            CGAffineTransform newTransform = CGAffineTransformConcat(existingTransform, t2);
            [layerInstruction setTransform:newTransform atTime:kCMTimeZero];
        }
    }
    
    self.videoData.videoComposition.renderSize = videoSize;
    self.videoData.videoSize = videoSize;
    
    instruction.layerInstructions = @[layerInstruction];
    self.videoData.videoComposition.instructions = @[instruction];
}
@end
