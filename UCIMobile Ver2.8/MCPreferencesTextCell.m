

#import "MCPreferencesTextCell.h"

@implementation MCPreferencesTextCell

- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString *) reuseIdentifier
{
	if (!(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]))
		return nil;

	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;

	_textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 15, 200, 50)];
	_label = [[UILabel alloc] initWithFrame:CGRectMake(7, -1, 105, 50)];

	_label.font = [UIFont boldSystemFontOfSize:15];
	_label.backgroundColor = nil;
	_label.opaque = NO;

	_textField.delegate = self;
	_textField.textAlignment = UITextAlignmentLeft;
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
	_textField.font = [UIFont systemFontOfSize:15];
	_textField.adjustsFontSizeToFitWidth = YES;
	_textField.minimumFontSize = 14.;
	_textField.textColor = [UIColor colorWithRed:(50. / 255.) green:(79. / 255.) blue:(133. / 255.) alpha:1.];
	_textField.enablesReturnKeyAutomatically = NO;
	_textField.returnKeyType = UIReturnKeyDone;
	_textField.backgroundColor = nil;
	_textField.opaque = NO;

	[self.contentView addSubview:_label];
	[self.contentView addSubview:_textField];

	return self;
}

- (void) dealloc 
{
	[_textField resignFirstResponder];
	_textField.delegate = nil;

	[_textField autorelease]; // Use autorelease to prevent a crash.
	[_label release];

	[super dealloc];
}

@synthesize textField = _textField;

- (NSString *) label 
{
	return _label.text;
}

- (void) setLabel:(NSString *) labelText 
{
	_label.text = labelText;
}

- (NSString *) text
{
	return _textField.text;
}

- (void) setText:(NSString *) text 
{
	_textField.text = text;

	[self setNeedsLayout];
}

- (void) setSelected:(BOOL) selected animated:(BOOL) animated 
{
	[super setSelected:selected animated:animated];

	if (self.selectionStyle == UITableViewCellSelectionStyleNone)
		return;

	if (selected) _textField.textColor = [UIColor whiteColor];
	else _textField.textColor = [UIColor colorWithRed:(50. / 255.) green:(79. / 255.) blue:(133. / 255.) alpha:1.];
}

- (void) setAccessoryType:(UITableViewCellAccessoryType) type
{
	super.accessoryType = type;

	if (type == UITableViewCellAccessoryDisclosureIndicator)
	{
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		_textField.textAlignment = UITextAlignmentRight;
		_textField.adjustsFontSizeToFitWidth = NO;
		_textField.userInteractionEnabled = NO;
	} 
	else 
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		_textField.textAlignment = UITextAlignmentLeft;
		_textField.adjustsFontSizeToFitWidth = YES;
		_textField.userInteractionEnabled = YES;
	}
}

- (void) prepareForReuse 
{
	[super prepareForReuse];

	self.label = @"";
	self.textField.text = @"";
	self.target = nil;
	self.textEditAction = NULL;
	self.accessoryType = UITableViewCellAccessoryNone;
	self.textField.placeholder = @"";
	self.textField.keyboardType = UIKeyboardTypeDefault;
	self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;

	[self.textField resignFirstResponder];
}

@synthesize textEditAction = _textEditAction;

- (BOOL) textFieldShouldBeginEditing:(UITextField *) textField 
{
	return (self.accessoryType == UITableViewCellAccessoryNone || self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton);
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField 
{
	[textField resignFirstResponder];
	return YES;
}

- (void) textFieldDidEndEditing:(UITextField *) textField 
{
	if (self.textEditAction && (!self.target || [self.target respondsToSelector:self.textEditAction]))
		[[UIApplication sharedApplication] sendAction:self.textEditAction to:self.target from:self forEvent:nil];
}
@end
