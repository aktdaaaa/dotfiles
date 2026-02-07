# GitHub CLI Commands for PR Comment Resolution

## PR Comment Retrieval

### Review Comments (inline code comments)
```bash
# Get all review comments on a PR
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --jq '.[] | {id, path, line, body, user: .user.login, created_at, in_reply_to_id, diff_hunk}'

# Get review comments with full context
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
```

### Issue Comments (general PR comments, not inline)
```bash
# Get general PR comments
gh api repos/{owner}/{repo}/issues/{pr_number}/comments --jq '.[] | {id, body, user: .user.login, created_at}'
```

### Pull Request Reviews (review summaries)
```bash
# Get reviews with their state (APPROVED, CHANGES_REQUESTED, COMMENTED)
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '.[] | {id, state, body, user: .user.login}'
```

### Combined: All comments via gh pr view
```bash
# Quick overview with comments
gh pr view {pr_number} --comments

# JSON with comments and review info
gh pr view {pr_number} --json comments,reviews,reviewRequests,body,title,number,url,headRefName
```

## Detect PR from Current Branch
```bash
# Get PR number for current branch
gh pr view --json number -q '.number'

# Get full PR info for current branch
gh pr view --json number,title,url,headRefName,comments,reviews
```

## Replying to Comments
```bash
# Reply to a review comment (inline)
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies -f body="message"

# Add a general PR comment
gh pr comment {pr_number} --body "message"
```

## Review Comment Fields
- `id`: Comment ID
- `path`: File path the comment is on
- `line`: Line number in the diff
- `original_line`: Original line number
- `body`: Comment text
- `user.login`: Author username
- `diff_hunk`: Surrounding diff context
- `in_reply_to_id`: Parent comment ID (for threaded replies)
- `created_at`: Timestamp
