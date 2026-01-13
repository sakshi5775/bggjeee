# Royal Vastu Compass Image Assets

## 📁 Required Image Files

This directory must contain the following PNG images for the Royal Vastu Compass:

### Layer Structure (Bottom to Top)

1. **outer_frame.png** (FIXED)
   - Embossed gold rim
   - Floral/mandala engravings
   - Bevel + inner shadow
   - Subtle radial glow
   - Size: 320x320px (or higher for retina)

2. **direction_ring.png** (ROTATES)
   - 16 directions (N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW)
   - Serif/Sanskrit-inspired typography
   - Micro tick marks
   - Size: 320x320px
   - Transparent background

3. **zone_good.png** (ROTATES, switches based on room logic)
   - Emerald green segments (#2E7D32)
   - Gradient shading (NOT flat)
   - Thin gold separators
   - Size: 320x320px
   - Transparent background

4. **zone_neutral.png** (ROTATES, switches based on room logic)
   - Sand gold segments (#E6CBA8)
   - Gradient shading
   - Thin gold separators
   - Size: 320x320px
   - Transparent background

5. **zone_bad.png** (ROTATES, switches based on room logic)
   - Deep vermilion red segments (#C62828)
   - Gradient shading
   - Thin gold separators
   - Size: 320x320px
   - Transparent background

6. **star.png** (ROTATES)
   - 16-point compass star
   - Metallic gold shading (#D4AF37)
   - Pseudo-3D depth
   - Needle tip softly glowing
   - Size: 320x320px
   - Transparent background

7. **needle.png** (FIXED - NEVER ROTATE)
   - North-pointing needle
   - Red tip (traditional compass style)
   - Metallic body
   - Size: 320x320px
   - Transparent background
   - ⚠️ IMPORTANT: This image NEVER rotates

8. **center_mandala.png** (FIXED, INTERACTIVE)
   - Vastu Purush Mandala
   - Soft pulse animation (handled in code)
   - Tap hotspot for lock/analysis
   - Size: ~100x100px (centered)
   - Transparent background

## 🎨 Design Specifications

### Color Palette
- **Background**: #FFF8E1 (Temple Ivory)
- **Royal Gold**: #D4AF37
- **Accent Orange**: #FF6B35
- **Good Zone**: #2E7D32 (Emerald Green)
- **Bad Zone**: #C62828 (Deep Vermilion)
- **Neutral**: #E6CBA8 (Sand Gold)

### Style Guidelines
- Heritage & Vastu Shastra inspired
- Luxury instrument feel
- Hand-crafted appearance
- NOT flat, NOT neon
- Premium embossed effects
- Glass-morphism depth

## 📐 Technical Requirements

- **Format**: PNG with transparency
- **Resolution**: 320x320px minimum (640x640px for @2x, 960x960px for @3x)
- **Background**: Transparent (except outer_frame)
- **Color Space**: sRGB
- **Optimization**: Compressed but high quality

## 🔄 Image Switching Logic

The zone ring image switches dynamically:
- `zone_good.png` → When room is in ideal direction
- `zone_bad.png` → When room is in avoid direction
- `zone_neutral.png` → When room is in neutral direction

**NO dynamic recoloring** - use separate images only.

## ⚠️ Critical Rules

1. ❌ NEVER rotate `needle.png`
2. ❌ NEVER use CustomPainter to draw compass
3. ❌ NEVER recolor images dynamically
4. ✔ Rotate ONLY: direction_ring, zone_ring, star
5. ✔ Keep outer_frame and needle FIXED
6. ✔ Switch zone images based on room logic

## 🎯 Design Prompt for AI/Designer

Create a luxury royal Vastu compass inspired by ancient Indian instruments.
Use a parchment ivory background (#FFF8E1) with royal gold embossed borders (#D4AF37).
Include:
- 16-direction metallic gold compass star
- Vastu Purush Mandala at the center
- Emerald green (favorable), muted gold (neutral), deep vermilion red (unfavorable) zones
- Engraved floral patterns
- Glass-like depth
- Elegant serif / Sanskrit-inspired typography

The design must feel like a premium physical instrument, not a flat UI element.

Export as separate PNG layers as specified above.









