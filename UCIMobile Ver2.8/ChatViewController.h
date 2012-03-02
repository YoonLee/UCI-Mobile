#import "Message.h"
#import "SoundEffect.h"

@class XMPPMessage;
@class XMPPClient;
@class XMPPJID;
@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
	NSMutableArray *messages;
	time_t	latestTimestamp;
	
	UITableView *chatContent;
	UILabel *msgTimestamp;
	UIImageView *msgBackground;
	UILabel *msgText;
	
	UIImageView *chatBar;
	UITextView *chatInput;
	CGFloat lastContentHeight;
	Boolean chatInputHadText;
	UIButton *sendButton;
	
	XMPPClient *forwardMSG;
	XMPPJID *opJID;
	SoundEffect *selectedSound;
}
@property(nonatomic, retain) XMPPJID *opJID;

-(id) initWithXmppClient:(XMPPClient *)client andOpponentChat:(NSArray *)msgs andJid:(XMPPJID *)jid;
-(void) slideFrameUp;
-(void) slideFrameDown;
-(void) slideFrame:(BOOL)up;
-(void) newMSGs:(Message *)msg;

@end