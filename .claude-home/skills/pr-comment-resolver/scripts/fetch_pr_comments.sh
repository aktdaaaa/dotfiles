#!/usr/bin/env bash
# Fetch all PR comments (review comments + issue comments + reviews) and changed files as structured JSON
# Usage: fetch_pr_comments.sh [PR_NUMBER]
#   If PR_NUMBER is omitted, auto-detects from current branch.

set -euo pipefail

PR_NUMBER="${1:-}"

if [ -z "$PR_NUMBER" ]; then
  PR_NUMBER=$(gh pr view --json number -q '.number' 2>/dev/null) || {
    echo "Error: No PR number provided and could not detect PR for current branch." >&2
    exit 1
  }
  echo "Auto-detected PR #${PR_NUMBER}" >&2
fi

REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')

echo "{"
echo "  \"pr_number\": ${PR_NUMBER},"
echo "  \"repo\": \"${REPO}\","

# PR basic info
echo "  \"pr_info\": $(gh pr view "$PR_NUMBER" --json title,body,url,headRefName,baseRefName,state),"

# Changed files list
echo "  \"changed_files\": $(gh pr view "$PR_NUMBER" --json files --jq '.files' 2>/dev/null || echo '[]'),"

# Review comments (inline code comments)
echo "  \"review_comments\": $(gh api "repos/${REPO}/pulls/${PR_NUMBER}/comments" --paginate 2>/dev/null || echo '[]'),"

# Issue comments (general comments)
echo "  \"issue_comments\": $(gh api "repos/${REPO}/issues/${PR_NUMBER}/comments" --paginate 2>/dev/null || echo '[]'),"

# Reviews (review summaries)
echo "  \"reviews\": $(gh api "repos/${REPO}/pulls/${PR_NUMBER}/reviews" --paginate 2>/dev/null || echo '[]')"

echo "}"
