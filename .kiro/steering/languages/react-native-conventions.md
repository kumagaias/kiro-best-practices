---
inclusion: fileMatch
fileMatchPattern: '**/*.(tsx|ts|jsx|js)'
description: React Native development best practices and performance optimization guidelines
---

# React Native Conventions

React Native development best practices and performance optimization.

**Usage**: Automatically included when working on React Native files, or use `#react-native-conventions` in chat.

---

## Official Resources

**📚 [Callstack Agent Skills - React Native Best Practices](https://github.com/callstackincubator/agent-skills)**

Comprehensive React Native optimization guidelines from Callstack, based on [The Ultimate Guide to React Native Optimization](https://www.callstack.com/blog/react-native-optimization-guide).

**Topics covered:**
- JavaScript/React: Profiling, FPS, re-renders, lists, state management, animations
- Native: iOS/Android profiling, TTI, memory management, Turbo Modules
- Bundling: Bundle analysis, tree shaking, R8, app size optimization

**Direct skill files:**
- [SKILL.md](https://github.com/callstackincubator/agent-skills/blob/main/skills/react-native-best-practices/SKILL.md) - Quick reference
- [references/](https://github.com/callstackincubator/agent-skills/tree/main/skills/react-native-best-practices/references) - Detailed guides

## Quick Reference

### Performance Best Practices

**Lists:**
- Use `FlatList` or `FlashList` for long lists (not `ScrollView`)
- Implement `getItemLayout` for fixed-height items
- Use `removeClippedSubviews` on Android

**Rendering:**
- Avoid inline styles and functions
- Use `React.memo` for expensive components
- Optimize re-renders with `useMemo` and `useCallback`

**Animations:**
- Use `react-native-reanimated` for 60fps animations
- Run animations on UI thread, not JS thread
- Avoid `Animated.timing` for complex animations

**Native:**
- Profile with Xcode Instruments (iOS) and Android Studio Profiler
- Optimize Time to Interactive (TTI)
- Use Turbo Modules for performance-critical native code

### Project Structure

```
src/
├── components/     # Reusable components
├── screens/        # Screen components
├── navigation/     # Navigation configuration
├── hooks/          # Custom hooks
├── services/       # API services
└── types/          # TypeScript types
```

### Component Pattern

```typescript
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

interface Props {
  title: string;
  onPress?: () => void;
}

export const Card = React.memo<Props>(({ title, onPress }) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
    </View>
  );
});

const styles = StyleSheet.create({
  container: {
    padding: 16,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
  },
});
```

## Common Pitfalls

- ❌ Using inline styles (use `StyleSheet.create`)
- ❌ Not optimizing list rendering
- ❌ Ignoring platform differences
- ❌ Running heavy operations on JS thread
- ❌ Not handling keyboard properly
- ❌ Forgetting safe area insets

---

**For detailed guidance:**
- [Callstack Agent Skills](https://github.com/callstackincubator/agent-skills) - React Native best practices
- [React Native Docs](https://reactnative.dev/docs/performance) - Official performance guide
- [Code Examples](https://github.com/callstack/optimization-best-practices) - Runnable examples

**Related guides:**
- #[[file:typescript-code-conventions.md]] - TypeScript standards
- #[[file:typescript-testing-standards.md]] - Testing patterns
