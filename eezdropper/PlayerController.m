#import "PlayerController.h"
#import "Track.h"

@interface PlayerController ()
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL paused;
@end

@implementation PlayerController

@synthesize player, rdio, loggedIn, playing, paused, tracks;

+ (PlayerController *)controller {
    return [[[PlayerController alloc] init] autorelease];
}

- (void)dealloc {
    [player release];
    [rdio release];
    [tracks release];
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

#pragma mark IBActions

- (IBAction) playClicked:(id) button {
    if (!self.playing) {
        NSArray* keys = [@"t2742133,t1992210,t7418766,t8816323" componentsSeparatedByString:@","];
        [self.player playSources:keys];
    } else {
        [self.player togglePause];
    }
}

- (IBAction) loginClicked:(id) button {
    if (self.loggedIn) {
        [self.rdio logout];
    } else {
        [self.rdio authorizeFromController:self];
    }
}

#pragma mark -
#pragma mark RdioDelegate

- (void) rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken {
    [self setLoggedIn:YES];
}

- (void) rdioAuthorizationFailed:(NSString *)error {
    [self setLoggedIn:NO];
}

- (void) rdioAuthorizationCancelled {
    [self setLoggedIn:NO];
}

- (void) rdioDidLogout {
    [self setLoggedIn:NO];
}


#pragma mark -
#pragma mark RDPlayerDelegate

- (BOOL) rdioIsPlayingElsewhere {
    return NO;
}

- (void) rdioPlayerChangedFromState:(RDPlayerState)fromState toState:(RDPlayerState)state {
    self.playing = (state != RDPlayerStateInitializing && state != RDPlayerStateStopped);
    self.paused = (state == RDPlayerStatePaused);
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
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[self.tracks objectAtIndex:indexPath.row] name];
    
    return cell;
}


@end
