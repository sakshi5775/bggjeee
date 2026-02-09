# Responsive Design Patterns - Quick Reference

## Common Overflow Fixes

### Pattern 1: Row Overflow

**❌ Before (Causes Overflow):**
```dart
Row(
  children: [
    Text('Long text that might overflow'),
    Icon(Icons.arrow_forward),
    Text('More text'),
  ],
)
```

**✅ After (Fixed):**
```dart
// Option A: Use Flexible/Expanded
Row(
  children: [
    Flexible(
      child: Text(
        'Long text that might overflow',
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.arrow_forward),
    Flexible(
      child: Text(
        'More text',
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)

// Option B: Use ResponsiveRow (auto-wraps on mobile)
ResponsiveRow(
  children: [
    Text('Long text that might overflow'),
    Icon(Icons.arrow_forward),
    Text('More text'),
  ],
)
```

### Pattern 2: Column Overflow

**❌ Before (Causes Overflow):**
```dart
Column(
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
    // ... many widgets
  ],
)
```

**✅ After (Fixed):**
```dart
// Option A: Add SingleChildScrollView
SingleChildScrollView(
  child: Column(
    children: [
      Widget1(),
      Widget2(),
      Widget3(),
    ],
  ),
)

// Option B: Use ResponsiveColumn (has built-in scroll)
ResponsiveColumn(
  enableScroll: true,
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)
```

### Pattern 3: Fixed Width Containers

**❌ Before (Causes Overflow on Small Screens):**
```dart
Container(
  width: 400, // Fixed width
  child: Text('Content'),
)
```

**✅ After (Fixed):**
```dart
// Option A: Use percentage width
Container(
  width: context.screenWidth * 0.9, // 90% of screen
  child: Text('Content'),
)

// Option B: Use constraints
Container(
  constraints: BoxConstraints(
    maxWidth: 400,
    minWidth: 200,
  ),
  child: Text('Content'),
)

// Option C: Use AdaptiveContainer
AdaptiveContainer(
  width: 400.w, // Responsive width
  child: Text('Content'),
)
```

### Pattern 4: Text Overflow

**❌ Before (Text Gets Cut Off):**
```dart
Text('Very long text that will overflow the container')
```

**✅ After (Fixed):**
```dart
// Option A: Add overflow handling
Text(
  'Very long text that will overflow the container',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)

// Option B: Use ResponsiveText
ResponsiveText(
  'Very long text that will overflow the container',
  maxLines: 2,
  autoScale: true,
)

// Option C: Use Flexible in Row
Row(
  children: [
    Flexible(
      child: Text(
        'Very long text',
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
```

### Pattern 5: Grid/List Overflow

**❌ Before (Items Don't Fit):**
```dart
Row(
  children: [
    Container(width: 150, child: Item1()),
    Container(width: 150, child: Item2()),
    Container(width: 150, child: Item3()),
  ],
)
```

**✅ After (Fixed):**
```dart
// Option A: Use Wrap
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    Container(width: 150, child: Item1()),
    Container(width: 150, child: Item2()),
    Container(width: 150, child: Item3()),
  ],
)

// Option B: Use ResponsiveWrap
ResponsiveWrap(
  spacing: 8,
  children: [
    Item1(),
    Item2(),
    Item3(),
  ],
)

// Option C: Use ResponsiveGrid
ResponsiveGrid(
  mobileColumns: 2,
  tabletColumns: 3,
  desktopColumns: 4,
  children: [
    Item1(),
    Item2(),
    Item3(),
  ],
)
```

## Responsive Utilities Usage

### Breakpoint Detection

```dart
// Check device type
if (context.isMobile) {
  // Mobile layout
} else if (context.isTablet) {
  // Tablet layout
} else {
  // Desktop layout
}

// Get adaptive value
final spacing = context.adaptiveValue(
  mobile: 8.0,
  tablet: 16.0,
  desktop: 24.0,
);
```

### Responsive Spacing

```dart
// Use predefined spacing
SizedBox(height: ResponsiveSpacing.md)

// Use responsive padding
Padding(
  padding: ResponsiveSpacing.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  child: child,
)

// Use app spacing presets
Padding(
  padding: AppSpacing.pagePadding,
  child: child,
)
```

### Screen Percentage Sizing

```dart
// Width as percentage
Container(
  width: ResponsiveUtils.widthPercent(context, 80), // 80% width
  child: child,
)

// Height as percentage
Container(
  height: ResponsiveUtils.heightPercent(context, 50), // 50% height
  child: child,
)
```

## Migration Checklist

When fixing a screen for responsiveness:

1. ✅ Replace fixed `Row` with `ResponsiveRow` or add `Flexible`/`Expanded`
2. ✅ Wrap scrollable `Column` with `SingleChildScrollView` or use `ResponsiveColumn`
3. ✅ Replace fixed widths with responsive widths (`.w` or percentage)
4. ✅ Add `overflow: TextOverflow.ellipsis` to all `Text` widgets
5. ✅ Use `Wrap` or `ResponsiveWrap` for horizontal lists
6. ✅ Replace fixed padding with `ResponsiveSpacing`
7. ✅ Test on mobile (320px), tablet (768px), and desktop (1440px)
