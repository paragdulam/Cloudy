//
//  CLBrowserCell.m
//  Cloudy
//
//  Created by Parag Dulam on 27/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBrowserCell.h"

@implementation CLBrowserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.image = [UIImage imageNamed:@"cell_background.png"];
        [self addSubview:backgroundImageView];
        [self sendSubviewToBack:backgroundImageView];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    backgroundImageView.frame = self.bounds;
    self.imageView.bounds = CGRectMake(0, 0, 30.f, 30.f);
    self.imageView.center = CGPointMake(20.f, roundf(self.contentView.center.y));
    
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 5.f;
    self.textLabel.frame = rect;

    rect = self.detailTextLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 5.f;
    self.detailTextLabel.frame = rect;

    
//
//    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 5.f,
//                                      0,
//                                      self.contentView.frame.size.width - 40.f,
//                                      self.imageView.frame.size.height/2);
//    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 5.f,
//                                      CGRectGetMaxY(self.textLabel.frame),
//                                      self.contentView.frame.size.width - 40.f,
//                                      self.imageView.frame.size.height/2);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
