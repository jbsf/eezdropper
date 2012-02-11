#import "TrackViewController.h"
#import "Track.h"
#import "PlayerController.h"
#import "AsyncImageView.h"

@interface TrackViewController ()
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, retain) NSArray *tracks;
@property (nonatomic, retain) PlayerController *playerController;
@end

@implementation TrackViewController

@synthesize 
rdio = rdio_,
tracks = tracks_,
playerController = playerController_,
contentView = contentView_,
tableViewCell = tableViewCell_;

- (id)initWithRdio:(Rdio *)rdio playerController:(PlayerController *)playerController {
    if (self = [super init]) {
        self.rdio = rdio;
        self.playerController = playerController;
    }
    return self;
}

- (void)dealloc {
    [playerController_ release];
    [rdio_ release];
    [tracks_ release];
    [super dealloc];
}

- (void)loadTracks {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"Track" forKey:@"type"];
    [self.rdio callAPIMethod:@"getTopCharts" withParameters:params delegate:self];
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
	[asyncImage loadImageFromURL:[NSURL URLWithString:track.iconURL]];
    
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


@end
