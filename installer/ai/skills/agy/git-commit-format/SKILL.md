---
name: git-commit-format
description: Enforce team git commit message format
---

When generating git commit messages:

Requirements:

1. Follow Conventional Commits.
2. Format:

<type>(<scope>): <summary>

- change 1
- change 2
- change 3

3. Allowed types:
   feat
   fix
   refactor
   perf
   test
   docs
   chore

4. Summary:
   - imperative mood
   - max 72 chars
   - lowercase

5. Output ONLY the commit message.
6. Do not wrap with markdown code blocks.
7. Do not add explanations.
