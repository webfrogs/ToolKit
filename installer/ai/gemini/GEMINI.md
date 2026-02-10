# GitHub PR Review Instructions

When performing a GitHub Pull Request (PR) review, you are explicitly authorized and encouraged to use the following tools and workflows:

## Tool Usage
- **gh (GitHub CLI)**: Use `gh` for all PR-related operations, including:
  - `gh pr view <pr_number>`: To see the PR title, body, status, and metadata.
  - `gh pr diff <pr_number>`: To fetch the code changes for review.
  - `gh pr view <pr_number> --comments`: To read existing review comments and discussion.
  - `gh pr comment <pr_number> --body "..."`: To post a high-level review summary or specific findings.
  - `gh pr review <pr_number> --comment --body "..."`: To submit a formal review.
- **git**: Use `git` to understand the repository structure, history, or to check out the PR branch locally if needed for deeper investigation (e.g., running tests).

## Review Workflow
1. **Gather Context**: Always start by viewing the PR description and existing comments.
2. **Analyze Changes**: Examine the diff thoroughly. Relate changes back to the project's existing patterns and architecture.
3. **Verify**: If possible, run relevant tests or build the project to ensure the PR doesn't introduce regressions.
4. **Constructive Feedback**: Provide clear, actionable feedback. Highlight security risks (e.g., SQL injection, Panics), logic errors, and deviations from project conventions.
5. **Language**: **All review comments and feedback must be written in Chinese.**
6. **Communicate**: Use `gh pr comment` or `gh pr review` to share your findings. Be professional and concise.

## Security & Safety
- Never expose secrets or sensitive data in comments.
- Adhere to all core safety mandates while using shell commands.
