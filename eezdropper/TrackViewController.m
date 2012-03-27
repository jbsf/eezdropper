#import "TrackViewController.h"
#import "Track.h"
#import "PlayerController.h"
#import "AsyncImageView.h"
#import "Blindside.h"

@interface TrackViewController ()
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, retain) NSArray *tracks;
@property (nonatomic, retain) PlayerController *playerController;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@end

@implementation TrackViewController

@synthesize 
rdio = rdio_,
tracks = tracks_,
playerController = playerController_,
imageCache = imageCache_,
contentView = contentView_,
userKey = userKey_,
tableViewCell = tableViewCell_;

+ (BSInitializer *)blindsideInitializer {
    SEL selector = @selector(initWithRdio:playerController:);
    return [BSInitializer initializerWithClass:self selector:selector argumentKeys:[Rdio class], [PlayerController class], nil];
}

- (id)initWithRdio:(Rdio *)rdio playerController:(PlayerController *)playerController {
    if (self = [super init]) {
        self.rdio = rdio;
        self.playerController = playerController;
        self.imageCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.playerController = nil;
    self.rdio = nil;
    self.tracks = nil;
    self.imageCache = nil;
    self.userKey = nil;
    [super dealloc];
}

- (void)loadTracks {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userKey forKey:@"user"];
    [params setValue:@"100" forKey:@"count"];
    [self.rdio callAPIMethod:@"getTracksInCollection" withParameters:params delegate:self];
}

- (void)viewDidLoad {
    self.tableView.backgroundColor = [UIColor colorWithRed:163/255.0 green:179/255.0 blue:193/255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:163/255.0 green:179/255.0 blue:193/255.0 alpha:1.0];
}

#pragma mark RDAPIRequestDelegate 

/**
 * Called when a request succeeds (request completes and 'status' is 'ok').
 * @param request The request that completed
 * @param data The 'result' field from the service response JSON, which can be an NSDictionary, NSArray, 
 *  or NSString etc. depending on the call.
 */
- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    self.tracks = [Track parseTracks:data];
    [self.tableView reloadData];
}

/**
 * Called when a request fails, either with a transport error, or the service JSON status field 'status' is 'error'.
 * @param request The request that failed
 * @param error If it is an NSHTTPURLResponse error the HTTP status code will be used as the error code. 
 *  If it is an Rdio API error the localizedDescription will contain the 'message' response.
 */
- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"bucket of fail");    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TrackCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TrackView" owner:self options:nil];
        cell = self.tableViewCell;
        [cell.contentView addSubview:self.contentView];
        self.tableViewCell = nil;
        self.contentView = nil;
    } else {
        AsyncImageView* oldImage = (AsyncImageView*) [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
        
    UIView *realContentView = [cell.contentView.subviews lastObject];
    UILabel *topLabel    = (UILabel *)[realContentView viewWithTag:1];
    UILabel *bottomLabel = (UILabel *)[realContentView viewWithTag:2];
    
    Track *track = [self.tracks objectAtIndex:indexPath.row];
    
    CGRect frame = CGRectMake(5, 4, 30, 30);
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
    
	asyncImage.tag = 999;
	[asyncImage loadImageFromURL:[NSURL URLWithString:track.iconURL] withCache:self.imageCache];
    
	[realContentView addSubview:asyncImage];

    topLabel.text = track.name;
    bottomLabel.text = track.artist;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Track *track = [self.tracks objectAtIndex:indexPath.row];
    [self.playerController playTrack:track];    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark -
#pragma mark RdioDelegate

- (void) rdioDidAuthorizeUser:(NSDictionary *)userData withAccessToken:(NSString *)accessToken {
    NSLog(@"TrackViewController authorization succeeded. token = %@", accessToken);
    NSLog(@"user data: %@", userData);
}

- (void) rdioAuthorizationFailed:(NSString *)error {
    NSLog(@"----------- TrackViewControlelr authorization failed with error: %@", error);
}

- (void) rdioAuthorizationCancelled {
    NSLog(@"----------- TrackViewController authorization cancelled");
}

- (void) rdioDidLogout {
    NSLog(@"-----------TrackViewController rdioDidLogout");
}

@end
