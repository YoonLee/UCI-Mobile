#import "ChatViewController.h"
#import "Message.h"
#import "ColorUtils.h"
#include <time.h>
#import <QuartzCore/QuartzCore.h>

#define MAINLABEL	((UILabel *)self.navigationItem.titleView)
#define BARBUTTON(TITLE, SELECTOR)	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

#define CHAT_BAR_HEIGHT_1	40.0f
#define CHAT_BAR_HEIGHT_4	94.0f
#define VIEW_WIDTH	self.view.frame.size.width
#define VIEW_HEIGHT	self.view.frame.size.height

#define RESET_CHAT_BAR_HEIGHT	SET_CHAT_BAR_HEIGHT(CHAT_BAR_HEIGHT_1)
#define EXPAND_CHAT_BAR_HEIGHT	SET_CHAT_BAR_HEIGHT(CHAT_BAR_HEIGHT_4)
#define	SET_CHAT_BAR_HEIGHT(HEIGHT) \
CGRect chatContentFrame = chatContent.frame; \
chatContentFrame.size.height = VIEW_HEIGHT - HEIGHT; \
[UIView beginAnimations:nil context:NULL]; \
[UIView setAnimationDuration:0.1f]; \
chatContent.frame = chatContentFrame; \
chatBar.frame = CGRectMake(chatBar.frame.origin.x, chatContentFrame.size.height, VIEW_WIDTH, HEIGHT); \
[UIView commitAnimations]; \

#define ENABLE_SEND_BUTTON	SET_SEND_BUTTON(YES, 1.0f)
#define DISABLE_SEND_BUTTON	SET_SEND_BUTTON(NO, 0.5f)
#define SET_SEND_BUTTON(ENABLED, ALPHA) \
sendButton.enabled = ENABLED; \
sendButton.titleLabel.alpha = ALPHA

@implementation ChatViewController
@synthesize opJID;
#pragma mark -
#pragma mark Initialization

- (id) initWithXmppClient:(XMPPClient *)client andOpponentChat:(NSArray *)msgs andJid:(XMPPJID *)jid
{
	messages = [[NSMutableArray alloc] init];
	NSBundle *mainBundle = [NSBundle mainBundle];
	selectedSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"pling" ofType:@"wav"]];
	
	time_t now; time(&now);
	
	for (Message *msg in msgs) 
	{
		NSDictionary *opponentMSGs = [[NSDictionary alloc] initWithObjectsAndKeys:msg, @"msg", @"opp", @"user", nil];
		msg.isNew = NO;
		[messages addObject:opponentMSGs];
		[opponentMSGs release];
	}
	
	forwardMSG = client;
	opJID = jid;
	
	return self;
}

// Recursively travel down the view tree, increasing the indentation level for children
- (void) dumpView: (UIView *) aView atIndent: (int) indent into:(NSMutableString *) outstring
{
	for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
	[outstring appendFormat:@"[%2d] %@ - (%f, %f) - %f x %f \n", indent, [[aView class] description], aView.frame.origin.x, aView.frame.origin.y, aView.bounds.size.width, aView.bounds.size.height];
	for (UIView *view in [aView subviews]) [self dumpView:view atIndent:indent + 1 into:outstring];
}

// Start the tree recursion at level 0 with the root view
- (NSString *) displayViews: (UIView *) aView
{
	NSMutableString *outstring = [[NSMutableString alloc] init];
	[self dumpView: self.view.window atIndent:0 into:outstring];
	return [outstring autorelease];
}

// Show the tree
- (void) displayViews
{
	CFShow([self displayViews: self.view.window]);
}

//	[self performSelector:@selector(displayViews) withObject:nil afterDelay:3.0f];

- (void)done:(id)sender 
{
	[chatInput resignFirstResponder]; // temporary
}

// Reveal a Done button when editing starts
- (void)textViewDidBeginEditing:(UITextView *)textView 
{
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(done:));
}

- (void)textViewDidChange:(UITextView *)textView 
{
	CGFloat contentHeight = textView.contentSize.height - 12.0f;
	
	if ([textView hasText]) 
	{
		if (!chatInputHadText)
		{
			ENABLE_SEND_BUTTON;
			chatInputHadText = YES;
		}
		
		if (textView.text.length > 1024)
		{ // truncate text to 1024 chars
			textView.text = [textView.text substringToIndex:1024];
		}
		
		// Resize textView to contentHeight
		if (contentHeight != lastContentHeight) 
		{
			if (contentHeight <= 76.0f) { // Limit chatInputHeight <= 4 lines
				CGFloat chatBarHeight = contentHeight + 18.0f;
				SET_CHAT_BAR_HEIGHT(chatBarHeight);
				if (lastContentHeight > 76.0f) {
					textView.scrollEnabled = NO;
				}
				textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
			} else if (lastContentHeight <= 76.0f) { // grow
				textView.scrollEnabled = YES;
				textView.contentOffset = CGPointMake(0.0f, contentHeight-68.0f); // shift to bottom
				if (lastContentHeight < 76.0f) {
					EXPAND_CHAT_BAR_HEIGHT;
				}
			}
		}	
	} else { // textView is empty
		if (chatInputHadText) {
			DISABLE_SEND_BUTTON;
			chatInputHadText = NO;
		}
		if (lastContentHeight > 22.0f) {
			RESET_CHAT_BAR_HEIGHT;
			if (lastContentHeight > 76.0f) {
				textView.scrollEnabled = NO;
			}
		}		
		textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk			
	}
	lastContentHeight = contentHeight;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
{
	textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
	return YES;
}

// Prepare to resize for keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
	//	NSDictionary *userInfo = [notification userInfo];
	//	CGRect bounds;
	//	[(NSValue *)[userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&bounds];
	
	//	// Resize text view
	//	CGRect aFrame = chatInput.frame;
	//	aFrame.size.height -= bounds.size.height;
	//	chatInput.frame = aFrame;
	
	[self slideFrameUp];
	// These methods can do better.
	// They should check for version of iPhone OS.
	// And use appropriate methods to determine:
	//   animation movement, speed, duration, etc.
}

// Expand textview on keyboard dismissal
- (void)keyboardWillHide:(NSNotification *)notification;
{
	//	NSDictionary *userInfo = [notification userInfo];
	//	CGRect bounds;
	//	[(NSValue *)[userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&bounds];
	
	[self slideFrameDown];
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView 
{
	[super loadView];
	
	// create chatContent
	chatContent = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, VIEW_WIDTH, VIEW_HEIGHT - CHAT_BAR_HEIGHT_1)];
	chatContent.clearsContextBeforeDrawing = NO;
	chatContent.delegate = self;
	chatContent.dataSource = self;
	chatContent.backgroundColor = [UIColor chatBackgroundColor];
	chatContent.separatorStyle = UITableViewCellSeparatorStyleNone;
	chatContent.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:chatContent];
	[chatContent release];
	
	// create chatBar
	chatBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, VIEW_HEIGHT - CHAT_BAR_HEIGHT_1, VIEW_WIDTH, CHAT_BAR_HEIGHT_1)];
	chatBar.clearsContextBeforeDrawing = NO;
	chatBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	chatBar.image = [[UIImage imageNamed:@"ChatBar.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
	chatBar.userInteractionEnabled = YES;
	
	// create chatInput
	chatInput = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 234.0f, 22.0f)];
	chatInput.contentSize = CGSizeMake(234.0f, 22.0f);
	chatInput.delegate = self;
	chatInput.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	chatInput.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	chatInput.scrollEnabled = NO; // not initially
	chatInput.scrollIndicatorInsets = UIEdgeInsetsMake(5.0f, 0.0f, 4.0f, -2.0f);
	chatInput.clearsContextBeforeDrawing = NO;
	chatInput.font = [UIFont systemFontOfSize:14.0];
	chatInput.dataDetectorTypes = UIDataDetectorTypeAll;
	chatInput.backgroundColor = [UIColor clearColor];
	lastContentHeight = chatInput.contentSize.height;
	chatInputHadText = NO;
	[chatBar addSubview:chatInput];
	[chatInput release];
	
	// create sendButton
	sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	sendButton.clearsContextBeforeDrawing = NO;
	sendButton.frame = CGRectMake(260.0f, 8.0f, 50.0f, 26.0f);
	sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	UIImage *sendButtonBackground = [UIImage imageNamed:@"SendButton.png"];
	[sendButton setBackgroundImage:sendButtonBackground forState:UIControlStateNormal];
	[sendButton setBackgroundImage:sendButtonBackground forState:UIControlStateDisabled];	
	sendButton.titleLabel.font = [UIFont boldSystemFontOfSize: 13];
	sendButton.backgroundColor = [UIColor clearColor];
	[sendButton setTitle:@"Send" forState:UIControlStateNormal];
	[sendButton addTarget:self action:@selector(sendMSG:) forControlEvents:UIControlEventTouchUpInside];
	sendButton.layer.cornerRadius = 13; // not necessary now that we'are using background image
	sendButton.clipsToBounds = YES; // not necessary now that we'are using background image
	DISABLE_SEND_BUTTON; // initially
	[chatBar addSubview:sendButton];
	[sendButton release];
	
	[self.view addSubview:chatBar];
	[self.view sendSubviewToBack: chatBar];
	[chatBar release];
	
	// Listen for keyboard
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)sendMSG:(id)sender 
{
	if ([chatInput hasText]) 
	{
		Message *msg = [[Message alloc] init];
		msg.text = chatInput.text;
		chatInput.text = @"";
		if (lastContentHeight > 22.0f) 
		{
			RESET_CHAT_BAR_HEIGHT;
			chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
			chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk			
		}		
		time_t now; time(&now);
		if (now < latestTimestamp+780) { // show timestamp every 15 mins
			msg.timestamp = 0;
		} 
		else 
		{
			msg.timestamp = latestTimestamp = now;
		}
		
		NSDictionary *meID = [[NSDictionary alloc] initWithObjectsAndKeys:msg, @"msg", @"me", @"user", nil];
		[messages addObject: meID];
		[forwardMSG sendMessage:msg.text toJID:opJID];
		
		[msg release];
		[meID release];
		meID = nil;
		msg = nil;
		
		[chatContent reloadData];
		NSUInteger index = [messages count] - 1;
		[chatContent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

-(void) newMSGs:(Message *)msg
{
	[selectedSound play];
	if (lastContentHeight > 22.0f) 
	{
		RESET_CHAT_BAR_HEIGHT;
		chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
		chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk	
	}
	
	NSDictionary *meID = [[NSDictionary alloc] initWithObjectsAndKeys:msg, @"msg", @"me", @"opp", nil];
	[messages addObject: meID];
	
	[meID release];
	meID = nil;
	
	[chatContent reloadData];
	NSUInteger index = [messages count] - 1;
	[chatContent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void) slideFrameUp 
{
	[self slideFrame:YES];
}

-(void) slideFrameDown 
{
	[self slideFrame:NO];
}

// Shorten height of UIView when keyboard pops up
-(void) slideFrame:(BOOL)up 
{
	const int movementDistance = 216; // set to keyboard variable	
	int movement = (up ? -movementDistance : movementDistance);
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];	
	CGRect viewFrame = self.view.frame;
	viewFrame.size.height += movement;
	self.view.frame = viewFrame;
	[UIView commitAnimations];
	
	if([messages count] > 0) {
		NSUInteger index = [messages count] - 1;
		[chatContent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
	chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
	chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [messages count];
}


#define TIMESTAMP_TAG 1
#define TEXT_TAG 2
#define BACKGROUND_TAG 3
#define MESSAGE_TAG 4

CGFloat msgTimestampHeight;

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSDictionary *messageID = [messages objectAtIndex:indexPath.row];
	Message *msg = [messageID objectForKey:@"msg"];
	NSString *type = [messageID objectForKey:@"user"];
	
    static NSString *CellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Create messageView to contain subviews (boosts scrolling performance)
		UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, cell.frame.size.width, cell.frame.size.height)];
		messageView.tag = MESSAGE_TAG;
		
		// Create message timestamp lable if appropriate
		msgTimestamp = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 12.0f)];
		msgTimestamp.clearsContextBeforeDrawing = NO;
		msgTimestamp.tag = TIMESTAMP_TAG;
		msgTimestamp.font = [UIFont boldSystemFontOfSize:11.0f];
		msgTimestamp.lineBreakMode = UILineBreakModeTailTruncation;
		msgTimestamp.textAlignment = UITextAlignmentCenter;
		msgTimestamp.backgroundColor = [UIColor chatBackgroundColor]; // clearColor slows performance
		msgTimestamp.textColor = [UIColor darkGrayColor];			
		[messageView addSubview:msgTimestamp];
		[msgTimestamp release];
		
		// Create message background image view
		msgBackground = [[UIImageView alloc] init];
		msgBackground.clearsContextBeforeDrawing = NO;
		msgBackground.tag = BACKGROUND_TAG;
		[messageView addSubview:msgBackground];
		[msgBackground release];
		
		// Create message text label
		msgText = [[UILabel alloc] init];
		msgText.clearsContextBeforeDrawing = NO;
		msgText.tag = TEXT_TAG;
		msgText.backgroundColor = [UIColor clearColor];
		msgText.numberOfLines = 0;
		msgText.lineBreakMode = UILineBreakModeWordWrap;
		msgText.font = [UIFont systemFontOfSize:14.0];
		[messageView addSubview:msgText];
		[msgText release];
		
		[cell.contentView addSubview:messageView];
		[messageView release];		
	} 
	else 
	{
		msgTimestamp = (UILabel *)[cell.contentView viewWithTag:TIMESTAMP_TAG];
		msgBackground = (UIImageView *)[[cell.contentView viewWithTag:MESSAGE_TAG] viewWithTag: BACKGROUND_TAG];
		msgText = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
	}
	
	if (msg.timestamp) 
	{
		msgTimestampHeight = 20.0f;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle]; // Jan 1, 2010
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];  // 1:43 PM
		
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:msg.timestamp];
		
		NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; // TODO: get locale from iPhone system prefs
		[dateFormatter setLocale:usLocale];
		[usLocale release];
		
		msgTimestamp.text = [dateFormatter stringFromDate:date];
		[dateFormatter release];
	} 
	else 
	{
		msgTimestampHeight = 0.0f;
		msgTimestamp.text = @"";
	}	
	
	CGSize size = [msg.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	UIImage *balloon;
	
	if ([type isEqualToString:@"me"]) 
	{
		msgBackground.frame = CGRectMake(320.0f - (size.width + 35.0f), msgTimestampHeight, size.width + 35.0f, size.height + 13.0f);
		balloon = [[UIImage imageNamed:@"bubbleGreen.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:13];
		msgText.frame = CGRectMake(298.0f - size.width, 5.0f + msgTimestampHeight, size.width + 5.0f, size.height);
	}
	else 
	{
		msgBackground.frame = CGRectMake(0.0f, msgTimestampHeight, size.width + 35.0f, size.height + 13.0f);
		balloon = [[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
		msgText.frame = CGRectMake(22.0f, 5.0f + msgTimestampHeight, size.width + 5.0f, size.height);
	}
	
	msgBackground.image = balloon;
	msgText.text = msg.text;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
	NSDictionary *messageID = [messages objectAtIndex:indexPath.row];
	Message *msg = [messageID objectForKey:@"msg"];
	msgTimestampHeight = msg.timestamp ? 20.0f : 0.0f;
	CGSize size = [msg.text sizeWithFont: [UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	return size.height + 20.0f + msgTimestampHeight;
} 

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc 
{
	[selectedSound release];
	selectedSound = nil;
	opJID = nil;
	[messages release];
	[super dealloc];
}

@end
