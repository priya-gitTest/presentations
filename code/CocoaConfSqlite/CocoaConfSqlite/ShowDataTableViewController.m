//
//  ShowDataTableViewController.m
//  CocoaConfSqlite
//
//  Created by Josh Smith on 3/25/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

#import "ShowDataTableViewController.h"

@interface ShowDataTableViewController ()
@property (assign) sqlite3 *db;
@property (strong) NSMutableArray *datasource;
@end

@implementation ShowDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int result = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSASCIIStringEncoding], &_db, SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE, NULL);
    NSAssert(result == SQLITE_OK,@"open completed correctly");
    
    const char *select_query = "select * from magfield";
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(_db, select_query, (int) strlen(select_query), &stmt, NULL);
    self.datasource = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        double x,y,z;
        const unsigned char *datetime;
        
        datetime = sqlite3_column_text(stmt, 0);
        x = sqlite3_column_double(stmt, 1);
        y = sqlite3_column_double(stmt, 2);
        
        if (sqlite3_column_type(stmt, 3) == SQLITE_FLOAT) {
            z = sqlite3_column_double(stmt, 3);
        }
        [self.datasource addObject:[NSString stringWithFormat:@"%s {%0.2f, %0.2f, %0.2f}",datetime,x,y,z]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"magnetic" forIndexPath:indexPath];
    cell.textLabel.text = self.datasource[indexPath.row];
    return cell;
}


@end
