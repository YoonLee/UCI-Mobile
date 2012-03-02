#import <Foundation/Foundation.h>
#import "XMPPElement.h"


@interface XMPPPresence : XMPPElement

+ (XMPPPresence *)presenceFromElement:(NSXMLElement *)element;

- (id)initWithType:(NSString *)type to:(XMPPJID *)to;

- (NSString *)type;
- (NSString *)show;
- (NSString *)status;
- (NSString *)photo;

- (int)priority;

- (int)intShow;

@end
