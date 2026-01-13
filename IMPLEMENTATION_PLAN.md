# Chat System Implementation Plan

## Current Status
- Data model file (`astrologer_chat_model.dart`) appears to be empty or missing
- Need to restore complete data model with all required fields
- Multiple features need implementation

## Implementation Order

### Phase 1: Foundation (CRITICAL - Do First)
1. **Restore/Complete Data Model**
   - Add ReplyData class for reply/quote feature
   - Ensure all message fields are present
   - Add token metadata support

2. **Fix Current Issues**
   - Timer stopping when session ends ✓ (Already done)
   - Rating dialog showing ✓ (Already done)  
   - Navigation after skip/rating ✓ (Already done)
   - Auto-detect when astrologer ends chat ✓ (Already done)

### Phase 2: Core Features (HIGH PRIORITY)
3. **Reply/Quote Feature**
   - Add reply data to message model
   - Implement swipe-to-reply or long-press
   - Show reply composer bar
   - Send reply payload
   - Receive and display replies
   - Scroll to original message on tap

4. **Double-Tick Read Status**
   - Single tick: SENT
   - Grey double tick: DELIVERED
   - Blue double tick: READ
   - Update via WebSocket events

5. **Astrologer Image Display**
   - Ensure images display identically
   - Fullscreen viewer
   - Download functionality
   - Error handling with retry

### Phase 3: Advanced Features
6. **Token-Based Seconds Deduction**
   - Formula: `min(max(20, ceil(total_tokens/700*40)), 180)`
   - Extract tokens from metadata
   - Deduct from timer

7. **Resume/Reconnect Logic**
   - Auto-detect active sessions
   - Navigate without snackbar
   - Sync messages on reconnect

8. **Chat History & Download**
   - History screen
   - Download transcript

## Next Steps
1. First, restore the data model file with all required classes
2. Add ReplyData class to model
3. Implement reply feature in controller and view
4. Fix read receipt display
5. Ensure image display works for both user and astrologer

## Estimated Time
- Phase 1: Foundation - 1-2 hours
- Phase 2: Core Features - 4-6 hours  
- Phase 3: Advanced Features - 3-4 hours

**Total: 8-12 hours of implementation**






