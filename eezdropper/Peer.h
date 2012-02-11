#import <Foundation/Foundation.h>

@class Track;

@interface Peer : NSObject<NSCoding>

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *iconURL;
@property (nonatomic, retain) NSString *rdioKey;

@property (nonatomic, retain) Track *track;

+ (Peer *)deserialize:(NSData *)data;

- (id)initWithIdentifier:(NSString *)identifier;
- (NSString *)name;
- (NSData *)serialize;

@end
