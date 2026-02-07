---
name: pr-comment-resolver
description: Analyze and resolve GitHub PR review comments by fetching comments, understanding the requested changes, proposing fixes, and applying them after user approval. Use when the user wants to address, fix, or respond to PR review comments, feedback, or requested changes. Triggers include "PR comments", "review feedback", "address PR feedback", "resolve comments", "fix review comments", "PR #123 comments", or when working on a branch with open review comments.
---

# PR Comment Resolver

Fetch, analyze, and resolve GitHub PR review comments. Present proposed fixes for user approval before applying changes.

**Prerequisite**: `gh` CLI must be authenticated (`gh auth status`).

## Workflow

### 1. Identify the PR

Determine the target PR:
- If user provides a PR number or URL: use it directly
- Otherwise: auto-detect from current branch via `gh pr view --json number -q '.number'`
- If auto-detection fails: ask user to specify

### 2. Fetch Comments

Run the bundled script to collect all comments:

```bash
bash <skill-path>/scripts/fetch_pr_comments.sh [PR_NUMBER]
```

This returns JSON with `review_comments` (inline), `issue_comments` (general), and `reviews` (summaries).

### 3. Filter Actionable Comments

From the fetched data, identify comments that require action:

- **Skip**: Comments that are resolved, outdated, or purely conversational (e.g., "LGTM", "Thanks!")
- **Prioritize**: Comments with `CHANGES_REQUESTED` review state
- **Group**: Thread replies together using `in_reply_to_id`
- **Categorize** each actionable comment:
  - **Code fix**: Bug, logic error, typo, or style issue pointing to specific code
  - **Refactor**: Structural improvement suggestion
  - **Question**: Reviewer asking for clarification (may not need code change)
  - **Suggestion**: Optional improvement or alternative approach

### 4. Present Analysis

For each actionable comment, present to user:

```
## Comment by @{user} on {path}:{line}
> {comment body}

**Category**: {category}
**Proposed action**: {description of what to change}
**Diff preview**:
  - {old code}
  + {new code}
```

Group related comments together. Present questions separately as they may only need a reply.

### 5. Apply Changes (after user approval)

Only after user confirms:
1. Apply code changes using Edit tool
2. For questions: draft reply text and confirm with user before posting
3. Optionally reply to resolved comments via `gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{id}/replies -f body="..."`

### 6. Summary

After applying changes, provide a summary:
- Number of comments addressed
- Files modified
- Any comments intentionally skipped with reason
- Suggest committing changes if any code was modified

## Comment Reply Guidelines

When replying to PR comments:
- Be concise and professional
- Reference the specific change made (e.g., "Fixed — changed X to Y as suggested")
- For questions: provide clear, direct answers
- Do not auto-reply without user approval

## References

- For `gh` CLI command details: see [references/gh-commands.md](references/gh-commands.md)
