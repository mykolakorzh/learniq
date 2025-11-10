#!/bin/bash
# Git Commit Reminder Script
# Run this script to check if you have uncommitted changes

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🔍 Checking Git status for Learniq..."
echo ""

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "${RED}❌ Not in a Git repository!${NC}"
    exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    echo "${YELLOW}⚠️  You have uncommitted changes:${NC}"
    echo ""
    git status --short
    echo ""
    echo "${YELLOW}📝 Reminder: Commit your changes regularly!${NC}"
    echo ""
    echo "Recommendations:"
    echo "  • ${GREEN}Commit after each feature/fix${NC}"
    echo "  • ${GREEN}Commit daily when actively developing${NC}"
    echo "  • ${GREEN}Always commit before TestFlight builds${NC}"
    echo ""
    echo "Quick commands:"
    echo "  git add .                           # Stage all changes"
    echo "  git add path/to/file                # Stage specific file"
    echo "  git commit -m \"type: description\"   # Commit with message"
    echo "  git push origin main                # Push to GitHub"
    echo ""

    # Check how many files are changed
    num_files=$(git status --porcelain | wc -l | tr -d ' ')
    if [ "$num_files" -gt 50 ]; then
        echo "${RED}⚠️  WARNING: You have $num_files files changed!${NC}"
        echo "${RED}   Consider breaking this into smaller commits.${NC}"
        echo ""
    fi

    exit 1
else
    echo "${GREEN}✅ No uncommitted changes. Good job!${NC}"
    echo ""

    # Check if local is ahead of remote
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")

    if [ -z "$REMOTE" ]; then
        echo "${YELLOW}⚠️  No remote branch configured${NC}"
    elif [ "$LOCAL" != "$REMOTE" ]; then
        echo "${YELLOW}📤 Your local branch has commits that haven't been pushed${NC}"
        echo "   Run: ${GREEN}git push origin main${NC}"
        echo ""
    else
        echo "${GREEN}✅ Local and remote are in sync!${NC}"
        echo ""
    fi

    # Show last commit
    echo "Last commit:"
    git log -1 --pretty=format:"  %h - %s (%cr by %an)" --abbrev-commit
    echo ""
    echo ""

    exit 0
fi
