---
name: dev-to-prod
description: Dennis's release order - PR from dev to main, wait for the gates, merge, verify the production deploy, leave dev in sync. Use when asked to "release", "PR dev to main", "deploy to prod", "put it on the live site" or similar.
---

# Dev to prod

The second half of the flow that `ship-to-dev` starts. In Dennis's repos
(dinkellabs-website, voetlink-app, website-stouwdamschilders-svelte and others
with the same setup) `dev` auto-deploys to the dev host and `main` auto-deploys
to production. Nothing reaches production except through a `dev` → `main` pull
request. Do every step, in order, and report the result of each; never stop
halfway without saying which steps are left.

## Before starting

- Confirm what is about to go live: `git log --oneline origin/main..origin/dev`.
  If it is empty, say so and stop; there is nothing to release.
- Confirm the version differs from `main` (`VERSION`, `package.json`, or the
  repo's equivalent). The `pr-source-gate` workflow rejects a release whose
  version did not change. If it is unchanged, ask before bumping: the bump is
  part of the dev release (`make bump VERSION=x.y.z` on `dev`, commit
  "Release x.y.z", push, let dev deploy), not something to slip into the PR.
- Confirm dev is actually running that version, from its health endpoint or
  `make version`. A release of something not seen on dev is not a release.

## Steps

1. **Pull request** with `gh pr create --base main --head dev`. Title
   "Release x.y.z to <production host>". Body: what changed since the previous
   release (read it from the commits, not from memory), what the deploy needs
   on the server, and how it was verified on dev. No AI footer, no mention of
   Claude or Anthropic.
2. **Wait for the gates**: `gh pr checks <n> --watch`. Expect the CI run, the
   source gate (head must be `dev`, version must be bumped) and the dev image
   build. If any check fails, report which and stop.
3. **Merge** with `gh pr merge <n> --merge` (merge commit, matching the repo
   history; never squash or rebase a release). Do not delete `dev`.
4. **Check the deploy.** The merge triggers the production workflow. Find it
   with `gh run list --branch main --limit 1`, wait with
   `gh run watch <id> --exit-status`, then read the production health or
   version endpoint until it reports the new version. Also fetch one page that
   carries the change and confirm it is there, and confirm production sends no
   `X-Robots-Tag: noindex` (that header belongs to dev only). If the deploy
   fails, report the failing job and stop; rollback is a `workflow_dispatch`
   of the previous immutable tag, which Dennis triggers.
5. **Leave the tree in order.** `git checkout dev && git pull --ff-only`,
   `git status` empty. `main` will be one merge commit ahead of `dev`; that is
   normal, do not merge it back.

## Report

End with: the PR number and merge commit, the deploy result, the version the
production health endpoint reports, the page check, anything the release still
needs outside the repo, and confirmation the tree is clean.

## Gotchas

- Branch protection is not available on the private repos, so the gates are
  advisory; the discipline is in following this order, not in GitHub
  refusing a merge.
- Infra changes live in the infra repo and are applied separately by Dennis.
  If the release depends on an env value or Caddy change that is not applied
  yet, say so before merging and let Dennis decide the order.
- The production server refuses to start without its bot-protection env in
  place; a deploy job that succeeds but a health endpoint that never answers
  usually means the container is restarting on a missing env value.
