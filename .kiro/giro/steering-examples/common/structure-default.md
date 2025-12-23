# Project Structure (Default/Platform Hosting)

General project structure for Vercel, Render, Railway, Forge, or similar platforms.

---

## Monorepo Structure

```
project-root/
├── frontend/              # Frontend application
│   ├── src/
│   │   ├── app/          # Next.js App Router
│   │   ├── components/   # React components
│   │   ├── lib/          # Utilities
│   │   └── types/        # TypeScript types
│   ├── public/           # Static assets
│   └── package.json
├── backend/               # Backend application
│   ├── src/
│   │   ├── routes/       # API routes
│   │   ├── services/     # Business logic
│   │   ├── repositories/ # Data access
│   │   ├── models/       # Data models
│   │   └── utils/        # Utilities
│   ├── tests/
│   └── package.json
├── .kiro/                 # Kiro configuration
├── scripts/               # Utility scripts
├── Makefile
└── README.md
```

## Frontend Structure (Next.js/React)

```
frontend/
├── src/
│   ├── app/              # Next.js App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── api/         # API routes (if using Next.js API)
│   ├── components/
│   │   ├── ui/          # Basic UI components
│   │   ├── features/    # Feature-specific components
│   │   └── layouts/     # Layout components
│   ├── lib/
│   │   ├── api/         # API client
│   │   └── utils.ts
│   ├── hooks/           # Custom React hooks
│   └── types/
├── public/
└── next.config.ts
```

## Backend Structure (Node.js/Express/Hono)

```
backend/
├── src/
│   ├── index.ts          # Entry point
│   ├── app.ts            # App configuration
│   ├── routes/           # API routes
│   │   ├── index.ts
│   │   ├── users.ts
│   │   └── posts.ts
│   ├── services/         # Business logic
│   │   ├── userService.ts
│   │   └── postService.ts
│   ├── repositories/     # Data access layer
│   │   ├── userRepository.ts
│   │   └── postRepository.ts
│   ├── models/           # Data models
│   │   ├── user.ts
│   │   └── post.ts
│   ├── middleware/       # Express/Hono middleware
│   │   ├── auth.ts
│   │   ├── cors.ts
│   │   └── errorHandler.ts
│   ├── config/           # Configuration
│   │   ├── database.ts
│   │   └── env.ts
│   └── utils/
│       ├── logger.ts
│       └── validation.ts
└── tests/
    ├── unit/
    └── integration/
```

## Database Options

### PostgreSQL (Recommended for Vercel/Render)
```
backend/src/
├── db/
│   ├── migrations/       # Database migrations
│   ├── seeds/            # Seed data
│   └── schema.sql        # Database schema
└── repositories/
    └── userRepository.ts # SQL queries
```

### MongoDB (Alternative)
```
backend/src/
├── models/
│   └── user.ts          # Mongoose models
└── repositories/
    └── userRepository.ts # MongoDB operations
```

### Prisma (ORM - Recommended)
```
backend/
├── prisma/
│   ├── schema.prisma    # Database schema
│   ├── migrations/      # Auto-generated migrations
│   └── seed.ts          # Seed script
└── src/
    └── repositories/
        └── userRepository.ts # Prisma client
```

## Deployment Configurations

### Vercel (vercel.json)
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "frontend/.next",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "nextjs",
  "regions": ["iad1"]
}
```

### Render (render.yaml)
```yaml
services:
  - type: web
    name: frontend
    env: node
    buildCommand: cd frontend && npm install && npm run build
    startCommand: cd frontend && npm start
    
  - type: web
    name: backend
    env: node
    buildCommand: cd backend && npm install && npm run build
    startCommand: cd backend && npm start
    
databases:
  - name: postgres
    databaseName: myapp
    user: myapp
```

### Railway (railway.json)
```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

## Environment Variables

### Frontend (.env.local)
```bash
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Backend (.env)
```bash
PORT=3001
DATABASE_URL=postgresql://user:pass@localhost:5432/myapp
JWT_SECRET=your-secret-key
NODE_ENV=development
```

## Development Workflow

```bash
# 1. Install dependencies
npm install
cd frontend && npm install && cd ..
cd backend && npm install && cd ..

# 2. Setup database
cd backend
npm run db:migrate
npm run db:seed

# 3. Start development servers
# Terminal 1: Backend
cd backend && npm run dev

# Terminal 2: Frontend
cd frontend && npm run dev
```

## Deployment Flow

### Vercel (Frontend)
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel --prod
```

### Render (Full Stack)
```bash
# Connect GitHub repository
# Render auto-deploys on push to main
```

### Railway (Full Stack)
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and deploy
railway login
railway up
```

## Architecture Patterns

### Monolithic (Simple Projects)
```
Frontend → Backend → Database
```

### API-First (Recommended)
```
Frontend → REST API → Database
         ↓
    Mobile App
```

### Microservices (Large Projects)
```
Frontend → API Gateway → Auth Service
                       → User Service
                       → Post Service
                       → Notification Service
```

## Best Practices

### Frontend
- Use Server Components when possible (Next.js)
- Implement proper error boundaries
- Use React Query for data fetching
- Optimize images with next/image
- Implement proper SEO

### Backend
- Use environment variables for configuration
- Implement proper error handling
- Use middleware for cross-cutting concerns
- Validate input data
- Implement rate limiting
- Use connection pooling for databases

### Database
- Use migrations for schema changes
- Implement proper indexes
- Use transactions for data consistency
- Implement soft deletes when appropriate
- Regular backups

### Security
- Use HTTPS in production
- Implement CORS properly
- Sanitize user input
- Use parameterized queries
- Implement rate limiting
- Use secure session management

## Monitoring

- Use platform-provided monitoring (Vercel Analytics, Render Metrics)
- Implement application logging
- Set up error tracking (Sentry, Rollbar)
- Monitor database performance
- Set up uptime monitoring

## Cost Optimization

- Use platform free tiers when possible
- Optimize bundle sizes
- Implement proper caching
- Use CDN for static assets
- Monitor resource usage
