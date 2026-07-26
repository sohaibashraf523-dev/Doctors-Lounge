# Doctors Lounge Codex Instructions

## Operating rule

Inspect the repository before editing. Prefer small, reviewable changes. Never claim an external service is connected merely because example configuration exists.

## Brand context

Doctors Lounge is a doctor-led health and wellness brand. Current honey-blend products include Gut Calm, Pulmo Care, ImmunoShield, MetaboFit, Vitality Gold, and CardioProtect. Preserve approved product names, formulations, available sizes, prices, and brand positioning from committed source files. Do not invent missing product facts.

## Medical and advertising safeguards

- Do not state or imply that a food, supplement, cosmetic, or wellness product diagnoses, treats, cures, reverses, or prevents disease.
- Use qualified wording such as “supports,” “may help support,” and “designed for,” only when substantiated.
- Never generate individualized diagnosis, treatment, dosage changes, or emergency advice for social-media users.
- Flag potentially noncompliant medical claims instead of silently polishing them.
- Require human approval before publishing health content, answering sensitive comments, changing prices, launching advertisements, or deleting content.

## Instagram and automation

- Prefer the official Meta APIs for durable integrations.
- Use browser automation only when an API cannot perform the task, and require supervision for publishing or account changes.
- Never commit access tokens, cookies, session files, passwords, browser profiles, or personal customer data.
- Default automation flow: collect metrics → analyse → create drafts → validate claims → human approval → publish.
- Do not auto-reply to medical questions, complaints, refund demands, adverse-event reports, or legal threats.

## Engineering standards

- Read existing code and documentation before making changes.
- Keep secrets in environment variables and provide `.env.example` with placeholders only.
- Add validation, error handling, structured logging, and clear setup instructions.
- Use Python 3.10+ for agent workflows unless the project already uses another stack.
- Run relevant tests or static checks after modifications. Report commands run and any failures.
- Do not modify vendored or upstream repositories inside `.tools/`.
- Avoid adding dependencies without a concrete need.

## Repository layout

- `integrations/`: manifests and integration documentation.
- `skills/`: project-specific reusable Codex skills.
- `scripts/`: setup and verification scripts.
- `.tools/`: local shallow clones of external repositories; ignored by Git.
- `.codex/`: repository-local example configuration. User-global secrets belong outside this repository.

## Response format for implementation tasks

Conclude with:

1. Files changed.
2. Validation performed.
3. Remaining manual setup.
4. Security or compliance risks.
