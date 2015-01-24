//
//  InterfaceController.m
//  WatchKitTest WatchKit Extension
//
//  Created by haruhito on 2015/01/24.
//  Copyright (c) 2015年 Fuji Haruhito. All rights reserved.
//

#import "InterfaceController.h"
#import "tablecustom.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *mytable;
@property (strong , nonatomic) NSMutableArray *entries;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.mytable setNumberOfRows:1 withRowType:@"default"];
    
    tablecustom *row = [self.mytable rowControllerAtIndex:0];
    [row.label setText:@"no data"];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)readBtnAction {
    if ([self.entries count] == 0) {
        NSString *url = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.dailynews.yahoo.co.jp/fc/rss.xml&num=10";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSError *error;
        NSDictionary *json_parsed = [NSJSONSerialization JSONObjectWithData:json_data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
        
        NSDictionary *responseData = [json_parsed objectForKey:@"responseData"];
        NSDictionary *feedData = [responseData objectForKey:@"feed"];
        self.entries = [feedData objectForKey:@"entries"];
    }
    
    NSInteger count = [self.entries count];
    
    [self.mytable setNumberOfRows:count withRowType:@"default"];
    
    for (int i = 0 ; i < count ; i++ ) {
        NSDictionary *entrie = [self.entries objectAtIndex:i];
        NSString *title = [entrie objectForKey:@"title"];
        //NSLog(@"%@",title);
        tablecustom *row = [self.mytable rowControllerAtIndex:i];
        [row.label setText:title];
    }
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSInteger i = rowIndex;
    [self.mytable setNumberOfRows:1 withRowType:@"default"];
    NSDictionary *entrie = [self.entries objectAtIndex:i];
    NSString *title = [entrie objectForKey:@"title"];
    tablecustom *row = [self.mytable rowControllerAtIndex:0];
    [row.label setText:title];

    
}

@end



