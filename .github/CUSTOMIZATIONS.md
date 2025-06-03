# CIPP-API Fork Customizations

This file documents all customizations made to this fork of CIPP-API to help prevent merge conflicts during upstream syncs.

## Important: This fork NEVER pushes to upstream

All synchronization is one-way: FROM upstream TO this fork.

## Custom Files Added

1. `.github/workflows/auto-sync-upstream.yml` - Automated sync workflow
2. `.github/CUSTOMIZATIONS.md` - This documentation file

## Modified Files

List any files that have been customized in this fork:

### Example format:
```
File: Modules/CustomModule.psm1
Changes: Added custom API endpoints
Conflict Resolution: Keep our version during merges
```

## Merge Conflict Resolution Strategy

When conflicts occur during upstream syncs:

1. **package.json** - Usually keep upstream dependencies, but preserve any custom scripts
2. **version files** - Always take upstream version
3. **Custom modules** - Keep our customizations
4. **Configuration files** - Review case by case
5. **Azure Function settings** - Keep our Azure-specific configurations

## Environment-Specific Settings

Document any environment-specific settings that should be preserved:

- Azure Function App configuration
- Connection strings
- Custom environment variables
- API keys and secrets (reference only, not actual values)

## Notes

- The auto-sync workflow runs daily at 2 AM UTC
- Manual sync can be triggered from GitHub Actions
- Conflicts will create a PR for manual resolution
- Never modify upstream repository
