#import "PeerViewController.h"

@interface PeerViewController ()
@property (nonatomic, retain) NSMutableArray *peers;
@end

@implementation PeerViewController

@synthesize peers;

- (id)init {
    if (self = [super init]) {
        self.peers = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [peers release];
    [super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PeerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[self.peers objectAtIndex:indexPath.row] name];
    
    return cell;
}

#pragma mark PeerWatcherDelegage 

- (void)peerDidLeave:(Peer *)peer {
    [self.peers removeObject:peer];
    [self.tableView reloadData];
}

- (void)peerDidArrive:(Peer *)peer {
    if (![self.peers containsObject:peer]) {
        [self.peers addObject:peer];
        [self.tableView reloadData];
    }
}

@end
