//
//  MapViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import "ChatViewController.h"
#import "CustomTableViewCellCell.h"


@implementation ChatViewController


@synthesize loginController;
@synthesize registrationController;
@synthesize currentUser = _currentUser;
@synthesize textField;
@synthesize messages, myTableView, _cell, idArray;


- (void)dealloc
{
    [idArray release];
    [_cell release];
    [myTableView release];
    [textField release];
    [loginController release];
    [registrationController release];
    [currentUser release];
    [messages release];
    [super dealloc];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        idArray = [[NSMutableArray alloc] init];
        messages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self searchGeoData:nil];
    
    //Update data every 30 sec
    [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(searchGeoData:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark GeoData

- (void) searchGeoData:(NSTimer *) timer{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	QBLGeoDataSearchRequest *searchRequest = [[QBLGeoDataSearchRequest alloc] init];
	searchRequest.status = YES;
    searchRequest.sort_by = GeoDataSortByKindCreatedAt;
    searchRequest.perPage = 15;
	[QBLocationService findGeoData:searchRequest delegate:self];
	[searchRequest release];
}

- (void)completedWithResult:(Result *)result
{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if([result isKindOfClass:[QBLGeoDataPagedResult class]])
    {
        if (result.success)
        {
            QBLGeoDataPagedResult *geoDataSearchRes = (QBLGeoDataPagedResult *)result;

            BOOL isChanged = NO;
            for (QBLGeoData* geodata in geoDataSearchRes.geodatas)
            {
                NSNumber *geodataID = [NSNumber numberWithUnsignedInteger:geodata.ID];
                if(![idArray containsObject:geodataID])
                {
                    isChanged = YES;
                    [idArray addObject:geodataID];
                    [messages addObject:geodata];
                }
            }
            
            if(isChanged)
            {
                [myTableView reloadData];
            }
        }
    }
    else if ([result isKindOfClass:[QBLGeoDataResult class]])
    {
        if (result.success)
        {
            // Make cell for new message
            NSIndexPath* newMessageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            ((QBLGeoDataResult*)result).geoData.user = _currentUser;
            [messages insertObject:((QBLGeoDataResult*)result).geoData atIndex:0];
    
            [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newMessageIndexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        }
        else 
        {
            NSLog (@"Error happened :(");
        }
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [textField resignFirstResponder];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    CustomTableViewCellCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = _cell;
    }
    QBLGeoData* geodata = [messages objectAtIndex:[indexPath row]];
    
    cell.user.text = geodata.user.login;
    cell.status.text = geodata.status;
    cell.lon.text = [NSString stringWithFormat:@"%0.4f", geodata.longitude];
    cell.lat.text = [NSString stringWithFormat:@"%0.4f", geodata.latitude];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (IBAction) send:(id)sender
{
    // Show alert if user did not logged in
    if(_currentUser == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You must first be authorized." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign Up", @"Sign In", nil];
        [alert show];
        [alert release];
        return ;
    }
    
    if([textField.text length] == 0){
        return;
    }
    
    // hide keyboard
    [self dismissKeyboard];
    
    
    
    // post message
    QBLGeoData *geoData = [QBLGeoData currentGeoData];
	geoData.user = _currentUser;
    geoData.status = textField.text;
	[QBLocationService postGeoData:geoData delegate:self];
    
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 1:
            [self presentModalViewController:registrationController animated:YES];
            break;
        case 2:
            [self presentModalViewController:loginController animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    [_textField resignFirstResponder];
    [self send:_textField];
    return YES;
}

- (void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark -

-(void)dismissKeyboard
{
    [textField resignFirstResponder];
}



@end
