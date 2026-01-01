---
inclusion: manual
fileMatchPattern: '\.(ts|tsx|js|jsx)$'
---

# TypeScript/React/Node.js Technical Practices

Language-specific best practices for TypeScript/React/Node.js projects.

**Usage**: Include this guide by typing `#tech-typescript` in chat.

---

## Project Initialization

### Quick Start (Existing Project)

```bash
# 1. Clone repository
git clone <repository-url>
cd <project-name>

# 2. Install dependencies
npm ci
cd frontend && npm ci && cd ..
cd backend && npm ci && cd ..

# 3. Configure environment variables (if needed)
cp frontend/.env.local.example frontend/.env.local
cp backend/.env.local.example backend/.env.local

# 4. Run tests to verify setup
make test
```

### New Project Setup

#### Configure Project Structure

```bash
# Create project directories
mkdir -p frontend backend infra docs scripts

# Copy package.json templates
cp <template-project>/package.json .
cp <template-project>/frontend/package.json frontend/
cp <template-project>/backend/package.json backend/

# Update package.json with your project name
```

#### Install Dependencies

```bash
# Root dependencies
npm install

# Frontend dependencies
cd frontend && npm install && cd ..

# Backend dependencies
cd backend && npm install && cd ..
```

### Tool Installation

```bash
# Node.js (via nvm or asdf)
nvm install 24  # or version in .tool-versions
nvm use 24

# Make (usually pre-installed)
make --version
```

## TypeScript Conventions

### Naming
- **Variables/Functions**: camelCase (`userName`, `fetchData`)
- **Classes/Components**: PascalCase (`UserProfile`, `Button`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)
- **Booleans**: Prefix with `is`, `has`, `should` (`isLoading`)
- **Event Handlers**: Prefix with `handle` (`handleClick`)

### Best Practices
- Prefer `interface` over `type` for public APIs
- Specify explicit return types for exported functions
- Avoid `any` type (use `unknown` if needed)
- Minimize type assertions (`as`)
- Use optional chaining (`?.`) and nullish coalescing (`??`)

### Coding Style
- Use semicolons
- Single quotes (`'`) except in JSX
- 2 spaces indentation
- Max 100 characters per line
- Prefer arrow functions
- Use destructuring
- Use template literals

## Testing Strategy

### Coverage
- **Target**: 60% or higher
- **Unit Tests**: Jest/Vitest
- **Component Tests**: React Testing Library
- **E2E Tests**: Playwright
- **Integration Tests**: Supertest (backend)

### Test Organization
- Place tests near source files
- Use `.test.ts` or `.spec.ts` extension
- One test file per source file
- Use Page Object Model for E2E tests

### Test Commands

```bash
# Unit tests only
make test-unit

# E2E tests only
make test-e2e

# Lint checks only
make test-lint

# Vulnerability checks only
make test-vulnerabilities
```

## Security

### Dependency Security
```bash
# Check vulnerabilities
npm audit

# Fix automatically
npm audit fix

# Fix with breaking changes
npm audit fix --force
```

## Performance

### Frontend
- Use SSR/SSG appropriately
- Optimize images
- Code splitting
- CDN caching

### Backend
- Query optimization
- Parallel processing (`Promise.all`)
- Caching strategies
- Connection pooling

## Logging

```typescript
const logger = {
  info: (message: string, meta?: object) => {
    console.log(JSON.stringify({ level: 'info', message, ...meta }));
  },
  error: (message: string, error?: Error, meta?: object) => {
    console.error(JSON.stringify({ 
      level: 'error', 
      message, 
      error: error?.message,
      stack: error?.stack,
      ...meta 
    }));
  },
};
```

## Prohibited Practices

### Code Quality
- ❌ Excessive use of `any` type
- ❌ Omitting error handling
- ❌ Console logs in production
- ❌ Large files (> 500 lines per file)

### Performance
- ❌ Unlimited data fetching
- ❌ Synchronous mass API calls

## Code Review Best Practices

### Common Issues to Address

1. **Error Messages**: Include HTTP status and specific details
2. **useEffect Dependencies**: Include all used variables/functions
3. **Hardcoded Text**: Use i18n translation keys
4. **Input Validation**: Validate at function start with clear errors
5. **Empty Data Handling**: Check before processing, provide fallback UI
6. **Accessibility**: Always provide alt text fallbacks
7. **Performance**: Use `useMemo` for expensive operations

### Response Priority

- **High**: Security, error handling, accessibility
- **Medium**: Performance, type consistency, i18n
- **Low**: Code duplication, nitpicks

### When to Refactor

- **3+ duplications**: Extract to utility function
- **2 or fewer**: Leave as is (avoid over-abstraction)
