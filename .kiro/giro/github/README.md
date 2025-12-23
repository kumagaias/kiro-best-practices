# GitHub Configuration

GitHub workflows, templates, and automation.

## Structure

```
.kiro/github/
├── workflows/
│   ├── copilot-review.yml    # Auto-request Copilot review on PR
│   └── tests.yml             # Run tests on push/PR
├── ISSUE_TEMPLATE/
│   ├── bug_report.md         # Bug report template
│   └── feature_request.md    # Feature request template
├── PULL_REQUEST_TEMPLATE.md  # PR template
└── README.md                 # This file
```

**Note:** This directory is symlinked to `.github/` in the repository root.

## Setup

### Automatic Setup (via installer)

The installer automatically creates a symbolic link:
- `.github` → `.kiro/github`

No manual setup required.

### Customization

You can customize the workflows and templates:

```bash
# Edit workflows
vim .github/workflows/copilot-review.yml
vim .github/workflows/tests.yml

# Edit templates
vim .github/PULL_REQUEST_TEMPLATE.md
vim .github/ISSUE_TEMPLATE/bug_report.md
vim .github/ISSUE_TEMPLATE/feature_request.md
```

**Note:** Core files are version controlled. Add custom workflows/templates as needed.

## Workflows

### Copilot Review (copilot-review.yml)

Automatically requests GitHub Copilot review when a PR is opened or updated.

**Triggers:**
- PR opened
- PR synchronized (new commits)
- PR reopened

**Actions:**
1. Requests Copilot review with `@github-copilot review this PR`
2. Adds `copilot-review-requested` label

**Requirements:**
- GitHub Copilot subscription
- `pull-requests: write` permission

### Tests (tests.yml)

Runs all tests on push and PR.

**Triggers:**
- Push to `main` or `develop`
- PR to `main` or `develop`

**Actions:**
1. Setup Node.js 24
2. Install dependencies
3. Run `make test`
4. Upload coverage artifacts

## Templates

### Pull Request Template

Provides a structured format for PRs:
- Description
- Related issue
- Type of change
- Changes list
- Testing checklist
- Screenshots
- Review checklist

### Issue Templates

**Bug Report:**
- Bug description
- Reproduction steps
- Expected vs actual behavior
- Environment details
- Screenshots

**Feature Request:**
- Feature description
- Problem statement
- Proposed solution
- Alternatives considered
- Benefits

## Usage

### Creating a PR

When you create a PR, the template will automatically appear:

```bash
gh pr create
# Template will be pre-filled
```

### Creating an Issue

Choose a template when creating an issue:

```bash
gh issue create
# Select template: Bug Report or Feature Request
```

### Copilot Review

Copilot review is automatically requested when you:
1. Open a new PR
2. Push new commits to an existing PR

You can also manually request:

```bash
gh pr review <PR-number> --comment --body "@github-copilot review this PR"
```

## Customization

### Adding New Workflows

Create a new workflow file in `.github/workflows/`:

```yaml
name: My Workflow

on:
  push:
    branches: [main]

jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Hello World"
```

**Note:** Custom workflows can be added and will be gitignored unless explicitly committed.

### Modifying Templates

Edit the template files in `.github/`:
- `PULL_REQUEST_TEMPLATE.md`
- `ISSUE_TEMPLATE/bug_report.md`
- `ISSUE_TEMPLATE/feature_request.md`

**Note:** Changes to core templates should be committed to share with the team.

## Best Practices

1. **Always use templates** - They ensure consistency
2. **Link issues to PRs** - Use `Fixes #123` in PR description
3. **Wait for Copilot review** - Review Copilot's feedback before merging
4. **Keep workflows simple** - Complex workflows are hard to maintain
5. **Test workflows locally** - Use `act` to test GitHub Actions locally

## Troubleshooting

### Copilot review not working

Check:
1. GitHub Copilot subscription is active
2. Repository has Copilot enabled
3. Workflow has `pull-requests: write` permission

### Workflows not running

Check:
1. `.github/workflows/` directory exists: `ls -la .github/workflows/`
2. Workflow files are valid YAML
3. Repository has Actions enabled
4. Workflows are properly committed to the repository

### Templates not appearing

Check:
1. `.github/` directory exists in repository root
2. Template files are in correct location
3. Template files have correct frontmatter (for issue templates)
4. Repository settings allow issue templates
5. Templates are committed to the repository

## Related Documentation

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Issue Templates Documentation](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests)
