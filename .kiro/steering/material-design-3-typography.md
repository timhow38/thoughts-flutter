# Material Design 3 Typography Guidelines

## Complete Type Scale System
- **Display Large**: 57sp/64sp line height - For large hero text and marketing headlines
- **Display Medium**: 45sp/52sp line height - For prominent display text
- **Display Small**: 36sp/44sp line height - For smaller display text
- **Headline Large**: 32sp/40sp line height - For high-emphasis, short text
- **Headline Medium**: 28sp/36sp line height - For medium-emphasis headlines
- **Headline Small**: 24sp/32sp line height - For smaller headlines
- **Title Large**: 22sp/28sp line height - For medium-emphasis text shorter than body
- **Title Medium**: 16sp/24sp line height - For medium-emphasis text
- **Title Small**: 14sp/20sp line height - For smaller titles
- **Body Large**: 16sp/24sp line height - For long-form writing
- **Body Medium**: 14sp/20sp line height - For standard body text
- **Body Small**: 12sp/16sp line height - For smaller body text
- **Label Large**: 14sp/20sp line height - For prominent labels
- **Label Medium**: 12sp/16sp line height - For standard labels
- **Label Small**: 11sp/16sp line height - For small labels and captions

## Advanced Font System
- Use variable fonts when available for better performance and flexibility
- Implement proper font fallback chains: System fonts → Google Fonts → Generic fallbacks
- Support font weight variations: Thin (100), Light (300), Regular (400), Medium (500), Semi-bold (600), Bold (700), Extra-bold (800), Black (900)
- Apply optical sizing for better readability at different sizes
- Use proper font feature settings (ligatures, kerning, number spacing)
- Implement font loading strategies to prevent layout shifts

## Typography Color & Emphasis
- **High-emphasis text**: 87% opacity on light surfaces, 100% on dark surfaces
- **Medium-emphasis text**: 60% opacity on light surfaces, 74% on dark surfaces
- **Disabled text**: 38% opacity on light surfaces, 38% on dark surfaces
- Use proper color tokens: on-surface, on-surface-variant, on-primary, on-secondary
- Apply color harmonization with dynamic color system
- Implement proper contrast ratios for all text combinations

## Advanced Text Styling
- Use proper letter spacing: Display (-0.25sp), Headlines (0sp), Titles (0.15sp), Body (0.5sp), Labels (0.1sp)
- Implement text decoration appropriately: underlines for links, strikethrough for deleted content
- Apply proper text case: sentence case for most content, all caps sparingly for labels
- Use text shadows and effects judiciously and only when they enhance readability
- Implement proper text selection styling with brand colors

## Responsive & Adaptive Typography
- Scale typography based on screen density and user preferences
- Implement fluid typography that adapts to container width
- Use proper breakpoint-specific type scales for different screen sizes
- Support dynamic type scaling for accessibility (up to 200% scaling)
- Test typography with system font size settings (small, default, large, largest)
- Implement proper text wrapping and hyphenation for different languages

## Internationalization & Localization
- Support right-to-left (RTL) languages with proper text alignment
- Use appropriate fonts for different language scripts (Latin, CJK, Arabic, etc.)
- Implement proper line height adjustments for different writing systems
- Support vertical text layouts where culturally appropriate
- Use proper number formatting and currency display for different locales
- Implement text expansion considerations for translated content

## Advanced Implementation
- Use TextTheme.of(context) for consistent theme application
- Implement custom TextStyle extensions for brand-specific variations
- Use proper text rendering optimization (TextPainter, RichText)
- Apply text accessibility features: semantic labels, reading order, content descriptions
- Implement text animation and transitions following Material motion principles
- Use proper text input formatting and validation
- Support text selection, copying, and sharing functionality
- Implement search highlighting and text emphasis features