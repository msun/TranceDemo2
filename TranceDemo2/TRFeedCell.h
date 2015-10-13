//
//  TRFeedCell.h
//  TranceDemo2
//
//  Created by Matthew Sun on 10/13/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPost.h"

@interface TRFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) TRPost *post;

@end
