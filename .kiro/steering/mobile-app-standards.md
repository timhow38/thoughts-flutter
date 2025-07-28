# Mobile App Development Standards

## Advanced Performance Standards
- Target 60fps (16.67ms per frame) for smooth animations and 120fps for high-refresh displays
- Optimize app startup: cold start < 2 seconds, warm start < 500ms, hot reload < 100ms
- Implement advanced lazy loading: viewport-based rendering, progressive image loading, code splitting
- Use efficient state management with proper disposal: Provider, Riverpod, Bloc, or GetX
- Minimize widget rebuilds: const constructors, RepaintBoundary, AutomaticKeepAliveClientMixin
- Implement proper memory management: dispose controllers, cancel subscriptions, clear caches
- Use performance profiling tools: Flutter Inspector, DevTools, CPU profiler
- Optimize build methods: avoid heavy computations, use cached values, implement shouldRebuild logic

## Advanced User Experience Patterns
- Implement comprehensive loading states: skeleton screens, shimmer effects, progressive loading, pull-to-refresh
- Provide contextual error handling: network errors, validation errors, server errors with retry mechanisms
- Use advanced navigation patterns: nested navigation, tab persistence, deep linking, custom transitions
- Implement proper gesture handling: swipe actions, long press, drag and drop, multi-touch
- Apply haptic feedback strategically: selection feedback, impact feedback, notification feedback
- Use micro-interactions: button press animations, form validation feedback, progress indicators
- Implement proper empty states with actionable guidance and illustrations

## Comprehensive Platform Integration
- Follow platform-specific design systems: Material 3 for Android, Human Interface Guidelines for iOS
- Implement adaptive UI: responsive layouts, platform-specific components, native look and feel
- Handle system integration: status bar styling, navigation bar, safe areas, notches, dynamic island
- Support system features: sharing, deep linking, universal links, push notifications, background processing
- Implement proper lifecycle management: app state changes, background/foreground transitions
- Use platform channels for native functionality when needed
- Support platform-specific gestures and navigation patterns
- Handle device capabilities: camera, location, biometrics, sensors

## Advanced Data Management
- Implement offline-first architecture with proper sync strategies
- Use sophisticated caching: HTTP caching, database caching, image caching, API response caching
- Handle network connectivity: connection state monitoring, retry mechanisms, queue management
- Implement data persistence layers: SQLite with proper migrations, NoSQL solutions, key-value storage
- Use proper API integration: REST, GraphQL, WebSocket connections, real-time updates
- Implement data validation and sanitization at multiple layers
- Use proper error handling with exponential backoff and circuit breaker patterns
- Support data encryption and secure transmission

## Enhanced Security & Privacy
- Implement comprehensive input validation: client-side and server-side validation, SQL injection prevention
- Use secure storage solutions: encrypted SharedPreferences, Keychain/Keystore integration, biometric authentication
- Follow security best practices: certificate pinning, API key protection, code obfuscation
- Implement proper authentication: OAuth 2.0, JWT tokens, refresh token rotation, multi-factor authentication
- Handle permissions gracefully: runtime permissions, permission rationale, graceful degradation
- Support privacy features: data anonymization, user consent management, GDPR compliance
- Implement security monitoring: crash reporting, security event logging, vulnerability scanning

## Comprehensive Testing Strategy
- Write extensive unit tests: business logic, utilities, data models, state management
- Implement widget tests: UI components, user interactions, accessibility features
- Use integration tests: end-to-end user flows, API integration, database operations
- Perform platform testing: multiple devices, screen sizes, orientations, OS versions
- Validate accessibility: screen reader support, keyboard navigation, color contrast, touch targets
- Implement performance testing: load testing, memory leak detection, battery usage analysis
- Use automated testing: CI/CD integration, test coverage reporting, regression testing
- Conduct manual testing: usability testing, exploratory testing, edge case validation

## Advanced Code Organization & Architecture
- Follow clean architecture: presentation, domain, data layers with proper separation of concerns
- Implement proper folder structure: feature-based organization, shared components, utilities
- Use consistent naming conventions: PascalCase for classes, camelCase for variables, snake_case for files
- Apply SOLID principles: single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion
- Implement dependency injection: service locators, provider patterns, factory patterns
- Use design patterns appropriately: Repository, Factory, Observer, Command, Strategy patterns
- Keep widgets focused and composable: single responsibility, reusable components, proper abstraction
- Implement proper error handling: try-catch blocks, error boundaries, logging strategies
- Use code generation tools: json_serializable, freezed, build_runner for reducing boilerplate
- Apply proper documentation: inline comments, README files, API documentation, architecture decisions

## Advanced Development Practices
- Implement proper version control: Git flow, semantic versioning, conventional commits
- Use continuous integration/deployment: automated builds, testing, deployment pipelines
- Apply code quality tools: linting, formatting, static analysis, code coverage
- Implement proper logging: structured logging, log levels, remote logging, crash reporting
- Use feature flags for gradual rollouts and A/B testing
- Implement proper monitoring: performance monitoring, user analytics, error tracking
- Support multiple environments: development, staging, production with proper configuration management
- Use proper asset management: image optimization, font loading, resource bundling