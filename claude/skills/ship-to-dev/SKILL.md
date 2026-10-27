---
name: ship-to-dev
description: Dennis's default deploy order - commit, push, PR and merge to dev, verify the auto-deploy, clean the working tree. Use when asked to "commit, push, merge to dev", "ship this", "deploy to dev" or similar.
---

# Ship to dev

The standard way work leaves a feature branch in Dennis's repos (voetlink-app,
dinkellabs-website, website-stouwdamschilders-svelte, and others with the same
setup): a push to `dev` auto-deploys to the dev environment, `main` is released
separately. Do every step, in order, and report the result of each; never stop
halfway without saying which steps are left.

## Steps

1. **Commit** whatever is still uncommitted on the feature branch. Commit
   messages: plain prose explaining why, no AI co-author trailer, no
   "Generated with" footer, no mention of Claude or Anthropic. If the tree is
   already clean, say so and move on.
2. **Push** the branch: `git push -u origin <branch>`.
3. **Pull request into `dev`** with `gh pr create --base dev`. Use the
   `dinkellabs` gh account where the repo lives under that owner. The body
   states what changed, what a deploy needs on the server (env vars, infra
   changes), and how it was verified. No AI footer in the body either.
4. **Merge** with `gh pr merge <n> --merge --delete-branch` (merge commit,
   matching the repo history). Then `git checkout dev && git pull --ff-only`.
5. **Check the deploy.** The push to `dev` triggers the deploy workflow
   (`docker-publish.yml` in voetlink-app). Find the run with
   `gh run list --branch dev --limit 1`, wait with
   `gh run watch <id> --exit-status`, then compare versions:
   `make version` where the Makefile has it (voetlink-app: local, dev app,
   dev api, dev site must all show the merge commit; prod reporting
   "unreachable" is expected while prod does not exist). Where there is no
   `make version`, curl the dev site's `/version.json` or health endpoint and
   compare the commit. If the deploy fails, report the failing job and stop;
   do not retry blindly.
6. **Clean the working tree.** Delete the local feature branch, confirm the
   remote branch is gone, `git status` must be empty, and end on `dev` level
   with `origin/dev`.

## Report

End with: the merge commit, the deploy result and the versions seen, anything
the deploy still needs that lives outside the repo (for example env values in
dinkellabs-infra), and confirmation the tree is clean.

## Gotchas

- Remote CI beyond the deploy workflow is `workflow_dispatch` only; run
  `make ci` (or the repo's equivalent) locally before pushing if a check is
  wanted.
- Infra changes (Caddy, env files) live in dinkellabs-infra and are a separate
  branch, PR, `make tofu-apply` and pyinfra apply (`uv run pyinfra -y ...`;
  `pass-cli login` first, by Dennis). Never fold them into an app PR, and never
  apply without being asked.
- Do not merge the app PR and the infra PR in an order that leaves the site
  broken for visitors: if a feature needs a new env value, say so before the
  merge and let Dennis decide.
