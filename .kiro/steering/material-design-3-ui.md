# Material Design 3 UI Guidelines

## Dynamic Color System
- Implement Material You dynamic color extraction from user wallpaper/preferences
- Use complete color token system: primary, secondary, tertiary, error, neutral, neutral-variant
- Apply proper color roles: primary-container, secondary-container, tertiary-container, error-container
- Implement surface color hierarchy: surface, surface-dim, surface-bright, surface-container-lowest, surface-container-low, surface-container, surface-container-high, surface-container-highest
- Use inverse colors for high contrast elements: inverse-surface, inverse-on-surface, inverse-primary
- Support custom color harmonization and color scheme generation
- Implement proper color contrast checking and accessibility compliance

## Advanced Component Standards
- Use complete Material 3 component library: Cards (elevated, filled, outlined), Buttons (elevated, filled, filled-tonal, outlined, text), Extended FABs, Chips (assist, filter, input, suggestion)
- Implement Navigation components: Bottom navigation, Navigation rail, Navigation drawer, Top app bar (center-aligned, small, medium, large), Bottom app bar
- Use Input components: Text fields (filled, outlined), Dropdown menus, Date/time pickers, Sliders, Switches, Checkboxes, Radio buttons
- Apply Communication components: Badges, Progress indicators, Snackbars, Tooltips
- Implement Containment components: Bottom sheets, Dialogs, Dividers, Lists, Side sheets, Tabs
- Use proper component variants and configurations based on context

## Elevation & Surface Tinting
- Apply Material 3 elevation system using surface tints instead of shadows
- Use elevation levels: 0dp (surface), 1dp (elevated), 3dp (focused), 6dp (dragged), 8dp (navigation drawer), 12dp (modal)
- Implement proper surface tint overlay calculations
- Apply elevation consistently across similar components
- Use shadow-less elevation for better performance and modern aesthetics

## Shape System
- Implement complete shape scale: None (0dp), Extra small (4dp), Small (8dp), Medium (12dp), Large (16dp), Extra large (28dp), Full (50% of component height)
- Apply shape tokens consistently: small components use small shapes, large components use large shapes
- Use shape theming for brand expression while maintaining usability
- Implement proper corner radius for different component types
- Support shape customization through theme configuration

## Advanced Layout & Spacing
- Follow 4dp base unit with 8dp grid system for optimal touch targets
- Implement responsive layout patterns: List-detail, Supporting panel, Feed, Immersive
- Use proper spacing tokens: 4dp, 8dp, 12dp, 16dp, 20dp, 24dp, 32dp, 40dp, 48dp
- Apply layout density options: standard, comfortable, compact
- Implement proper breakpoint system: compact (0-599dp), medium (600-839dp), expanded (840dp+)
- Use adaptive layouts that transform based on screen size and orientation

## Motion & Transitions
- Implement Material motion principles: Informative, Focused, Expressive, Simple
- Use proper easing curves: Standard (0.2s), Decelerate (0.25s), Accelerate (0.2s)
- Apply shared element transitions for navigation continuity
- Implement proper enter/exit animations for components
- Use container transform transitions for related content
- Apply fade through transitions for unrelated content
- Implement proper loading and progress animations

## Advanced Navigation Patterns
- Use adaptive navigation: Bottom navigation (mobile), Navigation rail (tablet), Navigation drawer (desktop)
- Implement proper navigation hierarchy and information architecture
- Apply navigation badges and indicators appropriately
- Use proper navigation state management and deep linking
- Implement search integration within navigation patterns
- Support navigation accessibility with proper focus management

## Comprehensive Accessibility
- Ensure WCAG 2.1 AA compliance with proper contrast ratios
- Implement semantic markup and proper widget roles
- Support screen readers with meaningful content descriptions
- Provide keyboard navigation and focus indicators
- Implement proper touch target sizes (minimum 48dp)
- Support high contrast mode and reduced motion preferences
- Use proper color coding with additional visual indicators
- Implement voice control and switch control support