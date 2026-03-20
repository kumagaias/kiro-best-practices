---
inclusion: fileMatch
fileMatchPattern: '**/mobile/**/*,**/app.json,**/eas.json,**/*.tsx,**/*.jsx'
description: Expo and React Native development best practices and workflow
---

# Expo & React Native Best Practices

Essential resources for Expo and React Native development.

**Usage**: Automatically included when working on mobile files, or use `#expo-react-native` in chat.

---

## Getting Started

**Start here:**
- [Development Workflow Overview](https://docs.expo.dev/workflow/overview/) - Complete development workflow
- [Tutorial (Beginner to Advanced)](https://docs.expo.dev/tutorial/introduction/) - Step-by-step guide

## iOS Development

- [App Store Best Practices](https://docs.expo.dev/distribution/app-stores/) - App Store submission guidelines
- [Development Build Creation](https://docs.expo.dev/develop/development-builds/create-a-build/) - Create custom dev builds
- [Expo Go → Dev Build Migration](https://docs.expo.dev/develop/development-builds/expo-go-to-dev-build/) - Migration guide

## Build & Distribution

- [EAS Build](https://docs.expo.dev/build/introduction/) - Cloud build service
- [EAS Submit (App Store)](https://docs.expo.dev/submit/ios/) - App Store submission

---

## Development Approach

### CNG (Continuous Native Generation)
- Create project with `npx create-expo-app`
- No `android/` or `ios/` directories by default
- Generate native projects when needed: `npx expo prebuild`
- Simplifies React Native version upgrades and maintenance

### Development Build
- Custom "Expo Go" with any native libraries
- Full control over native configurations
- Build iOS apps without macOS using EAS

---

**Related guides:**
- #[[file:../react-native-conventions.md]] - React Native coding standards
- #[[file:../../tech.md]] - General technical practices
- #[[file:../../deployment-workflow.md]] - Deployment workflow
