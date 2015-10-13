//
//  TRFeedViewController.m
//  TranceDemo2
//
//  Created by Matthew Sun on 10/13/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

#import "TRFeedViewController.h"
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
            NSLog(@"GET Request error");
            return;
        } else if (data == nil) {
            NSLog(@"No data received");
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
                        post.picture = pictureObject;
                    }
                    
                    [posts addObject:post];
                } else {
                    NSLog(@"It wasn't a dictionary");
                }
            }
            
            self.posts = posts;
            NSLog(@"ok");
        } else {
            NSLog(@"It wasn't an array");
            return;
        }
    }] resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.backgroundColor = [UIColor redColor];
    
    [self updateData];
}

# pragma mark -
# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


# pragma mark -
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
