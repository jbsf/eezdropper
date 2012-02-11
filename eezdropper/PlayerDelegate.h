#import <Foundation/Foundation.h>

@class Track;

@protocol PlayerDelegate <NSObject>

- (void)playerDidStart:(Track *)track;
- (void)playerDidPause;
@end
