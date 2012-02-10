#import <Foundation/Foundation.h>

@class Track;

@interface Peer : NSObject

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Track *track;

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier track:(Track *)track;
@end
