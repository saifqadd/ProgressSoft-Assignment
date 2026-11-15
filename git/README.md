# Git and GitHub/GitLab command line

This folder documents the remote workflow. The local repository is on `main`, has no assignment commits, and has staged and unstaged work. `origin` is configured to the user's private GitHub project. The last read-only `git ls-remote --heads origin` query returned no branch refs. No assignment commit or push has been performed. Local Oracle/PostgreSQL passwords are ignored.

```bash
git status --short
git diff --cached --stat
git diff --cached
git config user.name "Your actual name"
git config user.email "Your verified email"
git commit -m "Add ProgressSoft technical assignment artifacts"
git push -u origin main
```

For this repository, `origin` is already configured. Do not add it again. Confirm the URL with `git remote -v` before the first push.

Use the provider's authenticated browser/credential manager or SSH key rather than placing a token in a URL. To download the project on another machine use `git clone <remote-url>`; within an existing clone use `git pull`. Common commands include `git log --oneline --decorate`, `git diff`, `git switch -c topic`, `git merge`, `git fetch`, `git status`, and `git restore --staged <path>`.

Before commit/push, check the staged file list and content. The confidential assignment PDF is outside this workspace and must never be copied into the remote. Do not stage `.env` files, credentials, database dumps, VM images, or private keys. The repository is private.
