---
name: pr-comment-resolver
description: Deeply investigate and resolve GitHub PR review comments. Fetches comments, performs comprehensive code impact analysis (call chains, dependencies, tests, existing patterns, performance), presents investigation results with recommendation level (Must/Should/Could/Skip) and multiple action options for each comment, then applies chosen fixes after user approval. Use when the user wants to address, fix, or respond to PR review comments, feedback, or requested changes. Triggers include "PR comments", "review feedback", "address PR feedback", "resolve comments", "fix review comments", "PR #123 comments", or when working on a branch with open review comments.
---

# PR Comment Resolver

Deeply investigate PR review comments, provide informed recommendations on whether to address each comment, and apply chosen fixes.

**Prerequisite**: `gh` CLI must be authenticated (`gh auth status`).

## Workflow

### 1. Identify the PR

- If user provides a PR number or URL: use it directly
- Otherwise: auto-detect from current branch via `gh pr view --json number -q '.number'`
- If auto-detection fails: ask user to specify

### 2. Fetch Comments

Run the bundled script to collect all comments and changed files:

```bash
bash <skill-path>/scripts/fetch_pr_comments.sh [PR_NUMBER]
```

Returns JSON with `review_comments`, `issue_comments`, `reviews`, `changed_files`, and `pr_info`.

### 3. Filter Actionable Comments

From the fetched data, identify comments that require investigation:

- **Skip**: Comments that are resolved, outdated, or purely conversational (e.g., "LGTM", "Thanks!", bot auto-comments)
- **Prioritize**: Comments with `CHANGES_REQUESTED` review state
- **Group**: Thread replies together using `in_reply_to_id`
- **Categorize** each actionable comment:
  - **Code fix**: Bug, logic error, typo, or style issue pointing to specific code
  - **Refactor**: Structural improvement suggestion
  - **Question**: Reviewer asking for clarification (may not need code change)
  - **Suggestion**: Optional improvement or alternative approach

### 4. Deep Investigation (per comment)

For each actionable comment, perform a comprehensive investigation. Refer to [references/investigation-guide.md](references/investigation-guide.md) for detailed techniques.

#### 4a. Code Impact Analysis
- Read the target file with surrounding context (±50 lines around the commented line)
- Use LSP `findReferences` and `incomingCalls` to trace callers and dependents of the target code
- Use Grep to search for the same pattern across the codebase
- Identify all files and functions that would be affected by the proposed change

#### 4b. Test Investigation
- Find related test files using Glob (`*_test.go` in the target package)
- Search for test functions that reference the target function/method
- Run the related tests to verify current behavior: `go test ./path/to/package/ -v -run TestName`
- Note whether the target code has adequate test coverage

#### 4c. Existing Pattern Consistency
- Search the codebase for similar implementations to check if the reviewer's suggestion aligns with existing patterns
- Check project guidelines (AGENTS.md, coding guidelines) for relevant conventions
- Determine if the comment points to a genuine inconsistency or a deliberate divergence

#### 4d. Performance Impact (when applicable)
- Check for N+1 queries, unnecessary memory allocation, loop-internal API/DB calls
- Only investigate when the comment relates to performance-sensitive code paths

### 5. Present Investigation & Options

For each investigated comment, present a structured analysis with multiple options:

```
---
## Comment #N by @{user} on {path}:{line}
> {comment body}

### Investigation Results
- **Impact scope**: {list of affected files and functions}
- **Related tests**: {test file names and coverage status}
- **Existing patterns**: {whether the suggestion aligns with codebase conventions}
- **Performance**: {impact assessment if applicable, otherwise "N/A"}

### Recommendation: {Must / Should / Could / Skip}
**Reasoning**: {clear explanation of why this recommendation level was chosen}

### Options
1. **Option A: {description}** (Recommended)
   - Changes: {specific code diff preview}
   - Pros: {benefits}
   - Cons: {drawbacks or risks}

2. **Option B: {alternative approach}**
   - Changes: {specific code diff preview}
   - Pros: {benefits}
   - Cons: {drawbacks or risks}

3. **Skip**
   - Reason: {template justification for not addressing}
   - Reply draft: "{suggested reply to reviewer explaining why}"
---
```

Present comments one at a time or in small batches. Wait for user's choice before proceeding.

### 6. Apply Changes (after user selection)

For each comment where the user selected an option:

1. Apply code changes using Edit tool
2. Run related tests to verify the change doesn't break anything
3. For questions: draft reply text and confirm with user before posting

### 7. Reply to Comments

After changes are applied and committed:

- Reply to each addressed comment with the commit hash and a concise description of the change
- Format: "{対応内容の説明} ({commit_hash})"
- For skipped comments: post the approved skip reason as a reply
- Always confirm reply content with user before posting
- Use `gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{id}/replies -f body="..."`

### 8. Summary

After all comments are processed:

```
## Summary
- **Addressed**: {count} comments ({list of comment numbers})
- **Skipped**: {count} comments ({list with reasons})
- **Files modified**: {list}
- **Tests run**: {pass/fail status}
- **Commits**: {commit hashes}
```

Suggest committing all changes if not already committed.

## Recommendation Level Guide

| Level | Criteria |
|-------|----------|
| **Must** | Bug fix, security issue, data integrity problem, build-breaking issue |
| **Should** | Code quality improvement, performance fix, guideline violation, missing test |
| **Could** | Refactoring suggestion, better naming, code style improvement |
| **Skip** | Preference-based, already consistent with existing patterns, out of PR scope |

## References

- For `gh` CLI command details: see [references/gh-commands.md](references/gh-commands.md)
- For investigation techniques: see [references/investigation-guide.md](references/investigation-guide.md)
