# AGENTS.md

*AWS Infrastructure – Terraform*

---

## 1. Purpose & High‑Level Guidance

This repository contains all Terraform code for provisioning and operating **AWS infrastructure** across `dev`, `staging`, and `prod` accounts.
When [YOUR_AI_AGENT] works here it must:

* **Add or change infrastructure** safely and idempotently.
* Produce pull‑requests (PRs) that pass *every* quality, security, and policy gate listed below.
* Keep the live environments stable—**never apply automatically**; human approval is mandatory.

---

## 2. Project Structure

| Path          | Description                                                          | [YOUR_AI_AGENT] May Edit? |
| ------------- | -------------------------------------------------------------------- | --------------- |
| `modules/`    | Re‑usable, versioned Terraform modules.                              | ✅ Yes           |
| `envs/<env>/` | Environment‑specific root modules (`main.tf`, `variables.tf`, etc.). | ✅ Yes           |
| `global/`     | Shared resources (e.g., IAM roles, S3 logging bucket).               | ✅ Yes           |
| `generated/`  | **Auto‑generated** provider schemas & docs.                          | ❌ **No**        |
| `scripts/`    | Helper bash scripts invoked by CI.                                   | ✅ Yes           |
| `.github/`    | CI workflows & agent configs.                                        | ✅ Yes           |

> **Do not** modify anything under `generated/` or files ending in `.generated.tf`; they are overwritten by automation.

---

## 3. Coding Conventions / Style Rules

| Topic             | Rule                                                                             |
| ----------------- | -------------------------------------------------------------------------------- |
| Terraform version | `>= 1.7.0, < 2.0`                                                                |
| Indentation       | 2 spaces, never tabs                                                             |
| Block order       | `terraform`, `provider`, `module`, `resource`, `data`, `output`, `locals`        |
| Naming            | `snake_case` for variables, `kebab-case` for resources when allowed              |
| Formatting        | `terraform fmt` must report **no changes**                                       |
| Linting           | `tflint` max severity ≤ *warning*; anything higher blocks                        |
| Docs              | Each module root must contain an auto‑generated `README.md` via `terraform-docs` |

---

## 4. Build, Test & Validation Commands

[YOUR_AI_AGENT] *must run these* in this order and wait for success:

```bash
# 1. Initialise & validate every workspace touched by the change
make init                         # wraps "terraform -chdir=<dir> init"
make validate                     # wraps "terraform -chdir=<dir> validate"

# 2. Static analysis & lint
make fmt-check                    # wraps "terraform fmt -recursive -check"
make lint                         # runs tflint with custom ruleset
make security-scan                # runs tfsec and checkov

# 3. Unit / integration tests
make terratest                    # Go‑based tests in tests/ directory

# 4. Generate docs (should produce no diff after running)
make docs                         # wraps terraform-docs

# 5. Cost estimation (optional; non‑blocking)
make infracost
```

All `make` targets are defined in the repo root `Makefile`.

---

## 5. Programmatic Checks & Security Gates

| Check                      | Tool                         | Blocking? | Threshold                   |
| -------------------------- | ---------------------------- | --------- | --------------------------- |
| Format                     | `terraform fmt -check`       | ✅ Yes     | No changes allowed          |
| Validation                 | `terraform validate`         | ✅ Yes     | Must pass                   |
| Lint                       | `tflint`                     | ✅ Yes     | Severity > *warning* blocks |
| Security                   | `tfsec`                      | ✅ Yes     | *High* findings block       |
| Security                   | `checkov`                    | ✅ Yes     | *Critical* findings block   |
| Policy                     | `Regula` (OPA)               | ✅ Yes     | Any violation blocks        |
| Drift detection (schedule) | `terraform plan` (read‑only) | 🕒 Daily  | Alerts only                 |
| Cost                       | `infracost`                  | 🚫 No     | Informational               |

[YOUR_AI_AGENT] must re‑run the full suite after every file it edits—even if the change is docs‑only—because policy checks read module metadata.

---

## 6. Pull‑Request Requirements

* **Title pattern**: `feat|fix|chore: <scope> - <summary>`
* **Body template** ([YOUR_AI_AGENT] must fill in):

  ```
  ## What
  <description>

  ## Why
  <reason>

  ## How
  <key implementation details>

  ## Validation
  - [ ] `make fmt-check`
  - [ ] `make validate`
  - [ ] `make security-scan`
  - [ ] `make terratest`
  ```
* Reference related issues with *closing* keywords (`Fixes #123`).
* Include the **output of `terraform plan`** as a collapsed code block for every affected workspace.

---

## 7. Environment Setup (CI & Local)

1. **Docker image**: `ghcr.io/our-org/tf-ci:latest` (contains Terraform, tflint, tfsec, checkov, infracost, Go 1.22, jq).
2. **AWS credentials** are injected by GitHub OIDC; they have *plan‑only* IAM permissions in CI.
3. **Backends**: All root modules use an S3 + DynamoDB state backend; the bucket/table are created out‑of‑band and mounted read‑only in CI.
4. Custom providers (e.g., Datadog) are mirrored in an internal Terraform Registry proxy.

[YOUR_AI_AGENT] should prefer using the **`make` targets**; they encapsulate all flags and env vars.

---

## 8. Agent Inventory

| # | Agent              | Trigger              | Main Tasks                                     | Owner     |
| - | ------------------ | -------------------- | ---------------------------------------------- | --------- |
| 1 | **Plan Agent**     | PR open/update       | `make init`, `terraform plan`, upload artifact | Dev Infra |
| 2 | **Validate Agent** | After #1             | `make validate`, `make fmt-check`, `make lint` | Dev Infra |
| 3 | **Security Agent** | After #2 + nightly   | `make security-scan`, enforce thresholds       | Security  |
| 4 | **Policy Agent**   | After #3             | `make regula`, block on violations             | Platform  |
| 5 | **Docs Agent**     | Post‑merge to `main` | `make docs`, commit changes                    | Dev Infra |
| 6 | **Cost Agent**     | `/cost` comment      | `make infracost`, comment diff                 | FinOps    |
| 7 | **Drift Agent**    | Daily 02:00 UTC      | Read‑only drift plan, alert Slack              | SRE       |
| 8 | **Release Agent**  | Git tag push         | Publishes modules to Registry, signs release   | Release   |
| 9 | **Refactor Agent** | `/refactor <path>`   | Uses [YOUR_AI_AGENT] to propose refactor PR              | Dev Infra |

> **Order is fixed.** Add new agents by appending rows; never renumber existing ones.

---

## 9. Scope & Precedence

1. The rules in this file apply to **all directories below its location**.
2. If another `AGENTS.md` exists deeper in the tree, its instructions **override** overlapping sections for that path subtree.
3. Explicit human or system instructions given in a [YOUR_AI_AGENT] prompt always **override** any `AGENTS.md`.

---

## 10. Location Hints

* Additional `AGENTS.md` files exist in:

  * `modules/network/` – networking module specific rules.
  * `modules/data/` – data‑layer provisioning specifics.

[YOUR_AI_AGENT] should merge guidance from all applicable files before acting.

---

## 11. Exclusions (Hard “Don’ts”)

* **Never** modify:

  * `generated/**`
  * Files with suffix `.generated.tf`
  * Migration history under `db/migrations/**`
* Do not commit secrets—CI enforces GitHub Secret Scanning.

---

## 12. Glossary

* **Root module** – Entry point containing `main.tf` that defines an environment stack.
* **Workspace** – Terraform CLI workspace tied 1‑to‑1 with an AWS account + stage.
* **Plan‑only IAM** – Role that allows `terraform plan` but **denies apply**.
* **DRY** – “Don’t Repeat Yourself”; consolidate duplicate code into modules.

---
