//
//  TRFeedViewController.m
//  TranceDemo2
//
//  Created by Matthew Sun on 10/13/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

#import "TRFeedViewController.h"
#import "TRFeedCell.h"
#import "TRPost.h"
#import <Foundation/Foundation.h>

@interface TRFeedViewController ()

@property (strong, nonatomic) NSArray *posts;

@end

@implementation TRFeedViewController

- (void)updateData {
    NSString *urlString = @"https://tranceapp.com/_utils/getData.php";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
        if (error != nil) {
            NSLog(@"JSON GET Request error");
            return;
        } else if (data == nil) {
            NSLog(@"No JSON data received");
            return;
        }

        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON was malformed");
            return;
        }
                
        self.posts = nil;

        if([jsonObject isKindOfClass:[NSArray class]]) {
            NSArray *jsonArray = jsonObject;
            NSMutableArray *posts = [[NSMutableArray alloc] init];
            
            for (id object in jsonArray) {
                TRPost *post = [[TRPost alloc] init];
                
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *jsonDictionary = object;

                    id nameObject = [jsonDictionary objectForKey:@"name"];
                    if ([nameObject isKindOfClass:[NSString class]]) {
                        post.name = nameObject;
                    }
                    
                    id pictureObject = [jsonDictionary objectForKey:@"picture"];
                    if ([pictureObject isKindOfClass:[NSString class]]) {
                        post.imageURL = pictureObject;
                    }
                    
                    [posts addObject:post];
                } else {
                    NSLog(@"It wasn't a dictionary");
                }
            }

            // Should use weak self here...
            dispatch_async(dispatch_get_main_queue(), ^{
                self.posts = posts;
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"It wasn't an array");
            return;
        }
    }] resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self updateData];
}

# pragma mark -
# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Feed Cell";
    TRFeedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.post = self.posts[indexPath.row];
    cell.nameLabel.text = cell.post.name;

    //cell.post.imageURL = @"http://sciactive.com/pnotify/includes/github-icon.png";
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL: [NSURL URLWithString:cell.post.imageURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
        if (error != nil) {
            NSLog(@"Image GET Request error");
            return;
        } else if (data == nil) {
            NSLog(@"No image data received");
            return;
        }

        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
        });
    }] resume];

    return cell;
}


# pragma mark -
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
