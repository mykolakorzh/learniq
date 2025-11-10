# Commit Guidelines for Learniq

## Overview
This document outlines best practices for committing and pushing code changes to maintain a clean, traceable Git history.

## When to Commit

### ✅ Commit After Each Logical Change
- **Feature completion**: Finished implementing a new screen or feature
- **Bug fixes**: Fixed a specific issue or bug
- **Refactoring**: Completed a refactoring task
- **Asset additions**: Added a new topic's images or updated existing ones

### ✅ Commit Daily
- At the end of each work session
- Before closing your development environment
- At least once per day when actively developing

### ✅ Commit Before TestFlight Builds
- **Always** commit all changes before creating a new build
- Update version number in `pubspec.yaml` as a separate commit
- Tag the commit with the build number (e.g., `v1.0.0+18`)

### ❌ Don't Wait Too Long
- Avoid accumulating 100+ files before committing
- Don't go multiple days without committing
- Don't commit untested code

## How to Write Good Commit Messages

### Format
```
<type>: <short description>

<optional detailed explanation>

<optional footer with issue references>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring without changing functionality
- `style`: UI/UX changes
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build scripts)
- `assets`: Adding or updating images, icons, or other assets
- `perf`: Performance improvements

### Examples

#### Good Commit Messages ✅
```
feat: Add statistics screen with progress charts

- Implement daily/weekly/monthly progress views
- Add chart library integration
- Create responsive layout for different screen sizes

Related to #42
```

```
fix: Resolve TTS pronunciation issue for German articles

The flutter_tts package was not handling "der/die/das" correctly.
Applied patch to fix the issue until upstream is updated.

Fixes #38
```

```
assets: Add Wohnung topic images (50 images)

- Add color and grayscale versions
- Optimize images for mobile display
- Update cards.json with new vocabulary
```

#### Bad Commit Messages ❌
```
updates
```

```
fixed stuff
```

```
Add app assets, build scripts, and clean up project structure
(703 files changed - too large!)
```

## Commit Workflow

### Daily Workflow
1. **Start work**
   ```bash
   git status                 # Check current state
   git pull origin main       # Get latest changes
   ```

2. **Make changes and test**
   - Write code
   - Test functionality
   - Run flutter analyze (if applicable)

3. **Stage and commit**
   ```bash
   git status                 # Review what changed
   git add <files>            # Stage specific files
   git commit -m "type: description"
   ```

4. **Push regularly**
   ```bash
   git push origin main       # Push to GitHub
   ```

### Before TestFlight Build
1. **Ensure all changes are committed**
   ```bash
   git status                 # Should show "nothing to commit"
   ```

2. **Update version**
   ```bash
   # Update pubspec.yaml: version: 1.0.0+19
   git add pubspec.yaml
   git commit -m "chore: Bump version to 1.0.0+19 for TestFlight"
   ```

3. **Tag the release**
   ```bash
   git tag v1.0.0+19
   git push origin main --tags
   ```

4. **Build for TestFlight**
   ```bash
   flutter clean
   flutter build ios --release
   ```

## Adding New Assets

When adding images or other assets:

### Small Changes (1-10 files)
```bash
git add assets/images/new_topic/*.png
git commit -m "assets: Add vocabulary images for new_topic"
git push origin main
```

### Large Changes (50+ files)
Break into topic-based commits:
```bash
# Commit 1
git add assets/images/fahrzeug/*
git commit -m "assets: Add Fahrzeug topic images (40 files)"
git push origin main

# Commit 2
git add assets/images/stadt/*
git commit -m "assets: Add Stadt topic images (45 files)"
git push origin main
```

## Quick Reference Commands

```bash
# Check what's changed
git status

# See detailed changes
git diff

# Stage all changes
git add .

# Stage specific files
git add path/to/file

# Commit with message
git commit -m "type: description"

# Push to GitHub
git push origin main

# View recent commits
git log --oneline -10

# Undo last commit (keeps changes)
git reset --soft HEAD~1

# Discard uncommitted changes
git restore <file>
```

## Tips for Success

1. **Commit often** - Small, frequent commits are better than large ones
2. **Test before committing** - Don't commit broken code
3. **Write clear messages** - Your future self will thank you
4. **Push regularly** - Treat GitHub as your backup
5. **Use branches for experiments** - Keep main stable
6. **Review before committing** - Use `git status` and `git diff`

## GitHub Repository
- Main branch: `main`
- Remote: https://github.com/mykolakorzh/learniq.git
- Always pull before starting work
- Always push after committing

## Questions or Issues?
If you're unsure about a commit:
1. Check this guide
2. Use `git status` to review changes
3. When in doubt, make smaller commits rather than larger ones

---

**Remember**: Frequent, small commits with clear messages make collaboration easier, bugs easier to track down, and your development history more valuable.
