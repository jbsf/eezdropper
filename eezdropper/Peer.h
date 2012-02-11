#import <Foundation/Foundation.h>

@class Track;

@interface Peer : NSObject<NSCoding>

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Track *track;

+ (Peer *)deserialize:(NSData *)data;

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier track:(Track *)track;
- (NSData *)serialize;
@end
