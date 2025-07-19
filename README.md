# terraform-ai-agent-guidelines

This repository demonstrates recommended workflows for AI agents that manage Terraform code for AWS infrastructure. It includes helper scripts and a Makefile that wrap common Terraform commands.

**Note:** Where the AGENTS.md file uses `YOUR_AI_AGENT`, replace it with the name of your AI agent.

## Structure

- `AGENTS.md` – policies and instructions for automated agents.
- `scripts/` – helper bash scripts used by the Makefile.
- `Makefile` – convenience targets for format, lint, security and testing.
- `go.mod` – Go module definition for terratest helpers.

Additional Terraform modules and environment directories can be added as the project grows.

## Usage

Execute the Makefile targets against a specific Terraform directory:

```bash
make init dir=<path>
make validate dir=<path>
```

Other available targets include `fmt-check`, `lint`, `security-scan`, `terratest`, `docs` and `infracost`