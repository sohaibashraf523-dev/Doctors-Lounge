---
name: doctors-lounge
summary: Create, audit, and automate Doctors Lounge content and workflows while preserving brand facts and medical-claim safeguards.
---

# Doctors Lounge Skill

Use this skill for Doctors Lounge website, social-media, content, product, analytics, and automation tasks.

## Workflow

1. Inspect committed brand and product source files before drafting.
2. Identify whether the task is analysis, content creation, implementation, publishing preparation, or automation.
3. Preserve exact product facts. Mark missing information instead of inventing it.
4. Apply the health-claim safeguards in the repository `AGENTS.md`.
5. For Instagram work, distinguish among:
   - audit only;
   - draft creation;
   - API integration;
   - supervised browser execution;
   - publishing requiring human approval.
6. Produce a clear deliverable and list any manual approvals or credentials still required.

## Default Instagram audit

Review:

- profile name, category, bio, link, and conversion path;
- profile image, grid consistency, Highlights, and brand recognition;
- content pillars and balance of Reels, carousels, stories, and static posts;
- hooks, captions, calls to action, saves, shares, watch time, profile visits, and follows;
- medical claims, misleading certainty, unsupported benefits, and missing disclaimers;
- conversion friction between content, WhatsApp, website, and purchase.

Do not infer performance from appearance alone. Request or analyse Instagram Insights when performance conclusions are required.

## Automation policy

Preferred architecture:

`Meta API → workflow engine → OpenAI analysis/drafting → claim validation → human approval → Meta publishing API`

Never expose secrets. Never publish sensitive health content or respond to medical questions without human review.
