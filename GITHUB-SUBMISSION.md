# How to publish this assignment on GitHub (for HR)

## 1. Create the repo

1. Go to GitHub → **New repository**
2. Name suggestion: `pm4-6558-coding-agent-assignment` or `coding-agent-skills-shipra-maurya`
3. **Private** unless HR asks for public
4. Do **not** initialize with README (you already have one)

## 2. Push only this folder (clean)

From your machine:

```bash
cd /Users/shipramaurya/final-task/PM4-6558-assignment

# Init git if not already
git init
git add .
git status   # confirm no .venv/ or target/ (see .gitignore)

git commit -m "PM4-6558 coding agent skills assignment — complete submission"

git branch -M main
git remote add origin git@github.com:YOUR_USERNAME/pm4-6558-coding-agent-assignment.git
git push -u origin main
```

## 3. What NOT to upload

- `**/.venv/`, `**/target/`, `**/node_modules/` (`.gitignore` handles this)
- Credentials, `.env`, MCP tokens, Bitbucket passwords
- Full `eq-order-hold-consumer` clone — **link to Bitbucket PR** instead (see README)

## 4. What to send HR

| Item | Where |
|------|--------|
| GitHub repo URL | Main deliverable |
| Jira ticket | https://paytmmoney.atlassian.net/browse/PM4-6558 |
| Google Doc self-eval | Link to filled doc |
| Repo self-eval | `00-basics-self-eval.md` (yes/no + evidence table) |
| Optional HR add-on | README § **How I used Cursor**, `docs/cursor-rules/`, agent vs manual table |
| Optional | Bitbucket PR #14 for PM4-6500 |

**Email template:**

> Hi,  
> Please find my coding agent skills assignment submission:  
> **GitHub:** https://github.com/YOUR_USERNAME/pm4-6558-coding-agent-assignment  
> **Jira:** PM4-6558 (In Review)  
> **Self-eval:** [Google Doc link] + `00-basics-self-eval.md` in repo  
> Start with `README.md` § **How to use this agent**, then `00-basics-self-eval.md` and `learnings.md`.

## 5. Optional stretch (HR / “how you use agents”)

Already included in this repo:

| Add-on | Location |
|--------|----------|
| Cursor rule snippets | `docs/cursor-rules/` (+ live copy in `.cursor/rules/`) |
| Reusable skills (any service) | `.cursor/skills/` — 10 skills (read + I3/I6 + A5) |
| How I used Cursor | README § How I used Cursor |
| Agent vs manual supervision | README table + `learnings.md` § Agent suggested vs manually verified |
| Basics self-eval (Garima-style) | `00-basics-self-eval.md` |

## 6. Other optional polish

- Add 2–3 screenshots to `docs/screenshots/` (Grafana, pytest green, Jira)
- 5-min Loom walkthrough of README + one live demo
- Pin the repo on your GitHub profile
