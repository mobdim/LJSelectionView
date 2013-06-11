//
//  LJSelectionView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionView.h"

@implementation LJSelectionView

/*
- (void)dealloc;
{
#if __has_feature(objc_arc)
    //
#else
    [super dealloc];
#endif
}
*/

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [self initWithFrame:frameRect]) {

    }
    return self;
}
/*
- (BOOL)acceptsFirstResponder; // TODO: test that we really need this? does it work properly?
{
    return YES;
}
*/
- (void)mouseUp:(NSEvent *)theEvent;
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if([theEvent clickCount] == 2) {
        [_delegate selectionView:self didDoubleClickatPoint:point];
    }
    else {
        [_delegate selectionView:self didSingleClickAtPoint:point];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
    NSPoint mouseStart = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint mouseCurrentLoc = mouseStart;
    NSPoint mouseLastLoc = mouseStart;
    NSPoint delta = NSZeroPoint;
    
    while (YES) {
        theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask];
        mouseCurrentLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        delta = NSMakePoint((mouseCurrentLoc.x-mouseLastLoc.x), (mouseCurrentLoc.y-mouseLastLoc.y));
        mouseLastLoc = mouseCurrentLoc;
        if ([theEvent type] == NSLeftMouseUp) {
            [_delegate selectionView:self didFinishDragFromPoint:mouseStart toPoint:mouseCurrentLoc delta:delta flags:[theEvent modifierFlags]];
            break;
        }
        else {
            if (!_canDragOutsideBounds && ![self mouse:mouseCurrentLoc inRect:[self bounds]]) {
                continue;
            }
            if (![_delegate selectionView:self shouldDragFromPoint:mouseStart toPoint:mouseCurrentLoc delta:delta flags:[theEvent modifierFlags]]) {
                break;
            }
        }
    }
}

@end
