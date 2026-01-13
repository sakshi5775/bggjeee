# Chat System Production-Ready Requirements

## Overview
This document outlines all requirements for making the chat system production-ready with AstroSage-like behavior.

## 1. Image Display & Handling

### Current Issue
When astrologer sends an image, user cannot view it properly or it displays differently than user-sent images.

### Requirements
- Display astrologer-sent images exactly like user-sent images
- Use `message.messageType === "IMAGE"` and `message.imageData.url` to load
- Show same preview, fullscreen modal, download, and save behavior
- Use `imageData.filename`, `size`, and `mimeType` for UI
- Handle S3 pre-signed URLs or public URLs with proper auth headers
- Show retry & download button on load failure

### Implementation Checklist
- [ ] Update image display in view to handle both user and astrologer images identically
- [ ] Add fullscreen image viewer
- [ ] Add download functionality
- [ ] Add error handling with retry

## 2. Double-Tick / Read Receipt Behavior

### Rules
- **Sending**: Show single tick (delivered to server)
- **Delivered**: Show grey double tick (recipient received but not read)
- **Read**: Show blue double tick (recipient read in active chat)

### Implementation
- Use WebSocket event `message_read` to mark as read
- Persist read state locally
- Only show blue double tick when backend confirms read
- Track: SENDING -> SENT -> DELIVERED -> READ

## 3. Reply (Quote) Feature - WhatsApp Style

### Gesture Support
- Swipe right on message OR long-press for action menu
- Show reply composer bar above input with message preview

### Payload Structure
```json
{
  "replyToMessageId": "MSG_1764938035713_0wcwu65g9",
  "replyToSenderId": "...",
  "replyToSnippet": "preview text or 'Image'"
}
```

### Receiving Reply
- Show reply UI inside message bubble (preview + new content)
- Tap reply preview → scroll to original message and highlight for 1s
- Works same in user and astrologer panels

## 4. WebSocket Handling

### Requirements
- All message sends, replies, read receipts, typing indicators over WebSocket
- Reconnect logic: sync missed messages and read states on reconnect
- Message states: SENDING -> SENT -> DELIVERED -> READ
- Image upload: upload to S3, send skeleton with clientMessageId, update with server messageId

## 5. Resume / Reconnect Logic

### Scenario
User accidentally navigates back or disconnects during session.

### Requirements
- Don't create new session if active session exists
- Auto-navigate to active session (no snackbar)
- Show non-blocking banner: "Resumed session X"
- Timer continues from backend authoritative state

## 6. Exit Chat / End Chat / Skip / Rating Flows

### Exit Chat Button
- If active: confirm → end session → navigate to summary
- If ended: close popup → navigate to history

### Skip & Rating
- Close popup on success
- Trigger backend endpoints
- Navigate appropriately (don't leave user stuck)
- Handle network failures with retry

## 7. Session Seconds / Timer Logic

### Formula (IMPORTANT)
```
deducted_seconds = min(max(20, ceil(total_tokens / 700 * 40)), 180)
```

### Implementation
- Compute deductions when tokens are used
- Same logic on client and server
- UI timer uses server as source of truth
- Local timer for smooth animation, re-sync on reconnect

## 8. Chat History & Download

### History Screen
- Show `messageStats` (totalMessages, userMessages, astrologerMessages, imagesShared)
- Download chat transcript via `api/chat/session/:chatId/download`
- Single-click download (JSON/HTML/PDF - prefer JSON)

### Download Output
- Include avatars, timestamps (sentAt), messageType (TEXT/IMAGE)

## 9. APIs to Use

All endpoints are in `end_points.dart`:
- `GET api/chat/sessions/history?page=1&limit=10`
- `GET api/chat/session/:chatId/messages`
- `GET api/chat/session/:chatId/download`
- Other endpoints already present

## Implementation Priority

1. **High Priority** (Critical for production):
   - [ ] Reply/Quote feature
   - [ ] Double-tick read status
   - [ ] Image display from astrologer
   - [ ] Token-based seconds deduction
   - [ ] Resume/reconnect logic
   - [ ] Exit/skip/rating flows

2. **Medium Priority**:
   - [ ] WebSocket reconnection with sync
   - [ ] Chat history screen
   - [ ] Download functionality

3. **Polish**:
   - [ ] Error states
   - [ ] Animations
   - [ ] Responsive design

## Testing Checklist

### Unit & Integration Tests
- [ ] Image messages from astrologer showing in user UI
- [ ] Reply flow: selection, payload, receive, navigation
- [ ] Read receipts (single -> double -> blue)
- [ ] Reconnect/resume: active session return
- [ ] Skip/rating/exit navigation

### Manual QA
- [ ] Upload image as astrologer → user sees it
- [ ] Reply to message → both sides show quote
- [ ] Simulate accidental back → resume session
- [ ] Timer deduction follows formula
- [ ] Download chat produces complete transcript






