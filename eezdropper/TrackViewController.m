#import "TrackViewController.h"
#import "Track.h"
#import "PlayerController.h"

@interface TrackViewController ()
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, retain) NSArray *tracks;
@property (nonatomic, retain) PlayerController *playerController;
@property (nonatomic, retain) MHLazyTableImages *lazyImages;
@end

@implementation TrackViewController

@synthesize 
rdio = rdio_,
tracks = tracks_,
playerController = playerController_,
contentView = contentView_,
lazyImages = lazyImages_,
tableViewCell = tableViewCell_;

- (id)initWithRdio:(Rdio *)rdio playerController:(PlayerController *)playerController {
    if (self = [super init]) {
        self.rdio = rdio;
        self.playerController = playerController;
        self.lazyImages = [[MHLazyTableImages alloc] init];
		self.lazyImages.placeholderImage = [UIImage imageNamed:@"trackPlaceholder"];
		self.lazyImages.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [playerController_ release];
    [rdio_ release];
    [tracks_ release];
    [lazyImages_ release];
	self.lazyImages.delegate = nil;
	[lazyImages_ release];
    [super dealloc];
}

- (void)loadTracks {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"Track" forKey:@"type"];
    [self.rdio callAPIMethod:@"getTopCharts" withParameters:params delegate:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.lazyImages.tableView = self.tableView;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.lazyImages.tableView = nil;
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
    }
    
    Track *track = [self.tracks objectAtIndex:indexPath.row];

    UIView *realContentView = [cell.contentView.subviews lastObject];
    UILabel *topLabel    = (UILabel *)[realContentView viewWithTag:1];
    UILabel *bottomLabel = (UILabel *)[realContentView viewWithTag:2];
        
    topLabel.text = track.name;
    bottomLabel.text = track.artist;
    
    [self.lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    
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

#pragma mark MHLazyTableImagesDelegate 

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath {
    Track *track = [self.tracks objectAtIndex:indexPath.row];
    NSLog(@"returning iconURL: %@", track.iconURL);
    return [NSURL URLWithString:track.iconURL];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
	[self.lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
	[self.lazyImages scrollViewDidEndDecelerating:scrollView];
}

- (UIImage*)postProcessLazyImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath {
    if (image.size.width != 35 && image.size.height != 35)
	{
        CGSize itemSize = CGSizeMake(35, 35);
		UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
    }
    else
    {
        return image;
    }
}

@end
