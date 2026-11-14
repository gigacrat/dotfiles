# Global preferences

## Git branching

Commit directly to the checked-out branch, including `main`/`master`. Do not
create a branch unless I ask.

Exception: before committing to a repo's default branch, check `git log` for
authors other than `gigacrat <gigacrat@proton.me>` and for open PRs. If
either exists, ask first.

## Commit messages

Use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):
`<type>(<scope>): <description>`. Do not adopt a different convention from a
repo's log; my older `scope(verb): description` commits predate this.

Types:

- `feat`, `fix`: changes behavior (new capability, or corrects wrong behavior).
- `refactor`: code change with no behavior change.
- `docs`: only comments or documentation change.
- `style`: only formatting or whitespace. Visual or theming changes are
  `feat` or `fix`.
- `perf`, `test`, `build`, `ci`, `chore`, `revert`: as in the spec.
- Breaking change: `!` before the colon and/or a `BREAKING CHANGE:` footer.

Scope: the package or top-level directory the change is in (e.g. `hypr`).
Omit it when the change spans the repo.

Subject line:

- At most 50 characters, counting the type and scope. Exceed 50 only when no
  accurate shorter wording exists; never exceed 72.
- Imperative mood, lowercase after the colon, no trailing period.

Body:

- Blank line after the subject; wrap at 72 characters.
- Explain why the change was made; the diff already shows what changed.
- Omit the body when the subject says everything.

Use American English spelling.

## Scope of a commit

- One logical change per commit; split unrelated changes into separate
  commits.
- Stage only the files and hunks that belong to the change. Leave other
  working-tree changes unstaged and tell me about them.

## When to commit and push

- Commit only when I ask. "Commit" means commit only.
- Push only when I ask for a push.
- Never amend, rebase, or force-push commits that are already pushed unless
  I ask.

## Code comments

- State non-obvious facts about the system or API that a reader could not
  infer from general principles, e.g. "window.active also fires for
  Hyprland's own internal focus changes".
- Do not describe removed or earlier approaches, even framed as design
  tradeoffs (e.g. "rather than a timer, which risks races, we..."). That
  restates generic engineering wisdom and documents code that no longer
  exists; git history covers it.
