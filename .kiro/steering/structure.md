# Project Structure

```
.
├── frontend/              # Frontend application
├── backend/               # Backend application
├── mobile/                # Mobile application (optional)
├── infra/                 # Infrastructure as Code
│   ├── environments/      # Environment-specific configurations
│   │   ├── dev/
│   │   ├── stag/
│   │   └── prod/
│   └── modules/           # Reusable infrastructure modules
│       ├── aws/           # AWS-specific modules
│       └── gc/            # Google Cloud-specific modules
├── docs/                  # Documentation
├── .kiro/                 # Kiro configuration
├── .tool-versions         # Tool version management (mise/asdf)
├── Makefile               # Build and test commands
└── README.md              # Project overview
```

## Directory Guidelines

### Infrastructure
- `infra/environments/`: Environment-specific configurations (dev, stag, prod)
- `infra/modules/`: Reusable infrastructure modules organized by cloud provider

### Application
- `frontend/`: Frontend application code (max 500 lines per file)
- `backend/`: Backend application code (max 500 lines per file)
- `mobile/`: Mobile application code (optional, max 500 lines per file)
- `docs/`: Additional documentation (split from README if needed)
- Tests are located within each application directory

## Notes

- Adapt this structure to your project needs
- Keep files under 500 lines (source) and 200 lines (docs)
- See #[[file:tech.md]] for development phases and workflow
