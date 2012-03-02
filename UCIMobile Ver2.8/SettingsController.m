
#import "SettingsController.h"
#import "MCPreferencesTextCell.h"
#import "SFHFKeychainUtils.h"
#import "User.h"
#define SMILE_SETTINGS_LOGIN_FIELD 1
#define SMILE_SETTINGS_PASSWORD_FIELD 2

@implementation SettingsController
@synthesize managedObjectContext;

- (id)init 
{
	return [super initWithStyle:UITableViewStyleGrouped];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // Custom initialization
		targets = [[NSMutableDictionary alloc] initWithCapacity:2];
		self.title = @"Configure";
		UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UCIJabber.png"]];
		UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebooked.png"]];
		UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GChat.png"]];
		
		servers = [[NSArray alloc] initWithObjects:imageview1, imageview2, imageview3, nil];
		[imageview3 release];
		[imageview2 release];
		[imageview1 release];
    }
    return self;
}

#pragma mark -

- (void)loginChanged:(MCPreferencesTextCell *)sender 
{
	[[NSUserDefaults standardUserDefaults] setObject:sender.textField.text forKey:@"login"];
}

- (void)passwordChanged:(MCPreferencesTextCell *)sender 
{
	NSError *error; 
	[SFHFKeychainUtils storeUsername:@"default" andPassword:sender.textField.text forServiceName:@"Smile" updateExisting:YES error:&error];
}

#pragma mark -

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView 
{
	return 2;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section 
{
	return section==0?2:servers.count ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	if (indexPath.section==0) 
	{
		MCPreferencesTextCell *cell = (MCPreferencesTextCell *)[self.tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
		if (!cell)
		{
			cell = [[[[MCPreferencesTextCell class] alloc] initWithFrame:CGRectZero reuseIdentifier:@"SettingsCell"] autorelease];
		}
		
		cell.target = self;
		
		if (indexPath.row == 1) 
		{		
			[targets setObject:indexPath forKey:@"passwd"];
			cell.label = NSLocalizedString(@"Password", @"Password setting label");
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			
			NSError *error;
			cell.textField.text = [SFHFKeychainUtils getPasswordForUsername:@"default" andServiceName:@"Smile" error:&error];
			
			cell.textEditAction = @selector(passwordChanged:);
			cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
			cell.textField.secureTextEntry = YES;
		} 
		else if (indexPath.row == 0) 
		{
			[targets setObject:indexPath forKey:@"id"];
			cell.label = NSLocalizedString(@"Login", @"Login setting label");
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			cell.textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"login"];
			cell.textEditAction = @selector(loginChanged:);
		}
		
		return cell;
	}
	else
	{
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		CGRect cellLength = cell.frame;
		UIImageView *imageView = [servers objectAtIndex:indexPath.row];
		CGRect imgLength = imageView.frame;
		
		if (indexPath.row==2) 
		{
			imgLength.origin.x = (cellLength.size.width / 2) - (imgLength.size.width / 2) + 13;
			imageView.frame = imgLength;
		}
		else if (indexPath.row==1)
		{
			imgLength.origin.x = (cellLength.size.width / 2) - (imgLength.size.width / 2);
			imgLength.origin.y = 5;
			imageView.frame = imgLength;
		}
		else
		{
			imgLength.origin.x = (cellLength.size.width / 2) - (imgLength.size.width / 2);
			imgLength.origin.y = 15;
			imageView.frame = imgLength;
		}

		
		[cell addSubview:imageView];
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section==1)
	{		
		MCPreferencesTextCell *cell_id = (MCPreferencesTextCell *)[tableView cellForRowAtIndexPath:(NSIndexPath *)[targets objectForKey:@"id"]];
		MCPreferencesTextCell *cell_passwd = (MCPreferencesTextCell *)[tableView cellForRowAtIndexPath:(NSIndexPath *)[targets objectForKey:@"passwd"]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		NSArray *key = nil;
		
		switch (indexPath.row) 
		{
			case 0:
				// load id and password from coredata
				cell_id.textField.text = @"";
				cell_passwd.textField.text = @"";
				key = [self fetch];
				if (key==nil||key.count==0) 
				{
					cell_id.textField.text = @"";
				}
				else
				{
					User *user = [key objectAtIndex:0];
					cell_id.textField.text = [NSString stringWithFormat:@"%@@uci.edu", user.netID];
					cell_passwd.textField.text = user.password;
					[self passwordChanged:cell_passwd];
				}
				break;
			case 1:
				// facebook default
				cell_id.textField.text = [NSString stringWithFormat:@"%@%@",cell_id.textField.text, @"@chat.facebook.com"];
				break;
			case 2:
				cell_id.textField.text = [NSString stringWithFormat:@"%@%@",cell_id.textField.text, @"@gmail.com"];
				break;
		}
		
		[self loginChanged:cell_id];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return section==1?@"Preset Servers:":@"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath.section==1?80:50;
}

#pragma mark -

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] init];
	barbutton.title = @"Clear";
	barbutton.target = self;
	barbutton.action = @selector(clean:);
	self.navigationItem.rightBarButtonItem = barbutton;
	[barbutton release];
	self.tableView.scrollEnabled = NO;
}

- (void) clean:(id)sender
{
	MCPreferencesTextCell *cell_id = (MCPreferencesTextCell *)[self.tableView cellForRowAtIndexPath:(NSIndexPath *)[targets objectForKey:@"id"]];
	MCPreferencesTextCell *cell_passwd = (MCPreferencesTextCell *)[self.tableView cellForRowAtIndexPath:(NSIndexPath *)[targets objectForKey:@"passwd"]];
	
	cell_id.textField.text = @"";
	cell_passwd.textField.text = @"";
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (NSArray *) fetch
{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	NSEntityDescription *description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
	[fetch setEntity:description];
	NSArray *user = [managedObjectContext executeFetchRequest:fetch error:nil];
	[fetch release];
	
	return user;
}

- (void)dealloc 
{
	[targets release];
	[servers release];
    [super dealloc];
}


@end
