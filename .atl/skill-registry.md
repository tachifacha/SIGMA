# Skill Registry - sigma

**Last Updated**: 2026-05-16
**Project**: sigma
**Stack**: PHP (vanilla), PDO, MySQL, JavaScript

## Project Context

This is a vanilla PHP application with:
- PDO database connectivity (MySQL)
- Plain JavaScript frontend
- Simple module-based architecture (compras_provision, ventas, stock, personal)
- No composer.json or package.json dependencies
- No testing framework
- No CI/CD pipeline detected

## Available Skills

| Skill | Status | Notes |
|-------|--------|-------|
| sdd-init | ✅ Available | SDD initialization |
| sdd-propose | ✅ Available | Create change proposals |
| sdd-spec | ✅ Available | Write delta specs |
| sdd-design | ✅ Available | Technical design |
| sdd-tasks | ✅ Available | Break changes into tasks |
| sdd-apply | ✅ Available | Implement tasks |
| sdd-verify | ✅ Available | Verify implementation |
| sdd-archive | ✅ Available | Archive completed changes |
| sdd-onboard | ✅ Available | Full SDD workflow |
| sdd-explore | ✅ Available | Explore SDD ideas |
| cognitive-doc-design | ✅ Available | Documentation design |
| comment-writer | ✅ Available | Collaboration comments |
| issue-creation | ✅ Available | GitHub issues |
| branch-pr | ✅ Available | Pull requests |
| judgment-day | ✅ Available | Dual review |

## Project-Specific Notes

- **No test runner detected**: PHP project without PHPUnit, Pest, or other testing frameworks
- **No linter/formatter**: No PHP CS Fixer, PHPStan, or similar tools
- **Persistence**: Engram (detected via git_remote)
- **Strict TDD**: Disabled (no test infrastructure)

## Recommended Next Steps

1. Run `/sdd-onboard` to walk through the full SDD workflow
2. Consider adding PHPUnit or Pest for testing if SDD workflow is adopted
3. Explore features with `/sdd-explore` to identify improvement areas