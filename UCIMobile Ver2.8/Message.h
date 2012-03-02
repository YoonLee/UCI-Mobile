#import <Foundation/Foundation.h>

@interface Message : NSObject 
{
	NSString* text;
	time_t timestamp;
	BOOL isNew;
//	uint32_t sender_id;
//	uint32_t receiver_id;
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, assign) time_t timestamp;
@property (nonatomic, assign) BOOL isNew;
//@property (nonatomic, assign) uint32_t sender_id;
//@property (nonatomic, assign) uint32_t receiver_id;

@end
