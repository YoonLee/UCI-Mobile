#import "Message.h"

@implementation Message

@synthesize text;
@synthesize timestamp;
@synthesize isNew;

- (id) init
{
	isNew = YES;
	
	return self;
}

- (NSString *) description
{
	return timestamp!=0?[NSString stringWithFormat:@"text:%@ timestamp:%d", text, timestamp]:text;
}

//@synthesize sender_id;
//@synthesize receiver_id;

@end
