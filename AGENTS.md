# AGENTS.md

> CRITICAL: Apply audit prompts from the `CRITICAL: Audit Prompt Compliance (Mandatory)` section before any code/review work.

## Repo overview
- Repo: `Phexora Aegis`
- App registry entries: aegis
- aegis: Phexora Aegis - privacy, scalability and post-quantum security research - static documentation site; domain aegis.phexora.ai; backend none (static site); frontend none; redis n/a; status none; enabled
- Registry source: `Libraries/Python/ApplicationRegistry.py` (ports, domains, scripts, Redis DBs)

## Quick start
- Read: `README.md`, `CLAUDE.md`, `Documentation/`
- Prefer startup scripts in `tools/Scripts/Startup`: `tools/Scripts/Startup/run_phexora_aegis.sh`
- Local start scripts in repo root: `start-local.bat`, `start-local.sh`

## Setup
- No dependency manifests detected; treat as docs/assets unless README says otherwise

## Commands
- Dev: `tools/Scripts/Startup/run_phexora_aegis.sh`, `start-local.bat`, `start-local.sh`

## Notes
- Deploy scripts: `tools/Scripts/Startup/phexora_aegis_deploy_script.sh`

## Fail-Fast Policy (Mandatory)
- For all Python changes, follow: `/mnt/d/workspace/VisualStudio/Libraries/Scripts/audit_prompts/03_defensive_programming_violations.md`.
- Do not add defensive fallbacks for required dependencies/fields.
- Do not use `hasattr()`/`getattr(..., default)` on required code paths.
- Do not use silent fallback patterns like `x = x or []`, `dict.get("key", default)` for required fields, or broad `except: return None`.
- Use direct access for required values and raise explicit exceptions when invariants are violated.
- Only keep fallback behavior when it is truly required by external systems/data quality and document it with `# REQUIRED FALLBACK:` including:
- Why it is required
- Evidence/example that triggers it
- What breaks if removed
## Audit Gate Workflow (Mandatory)
- Before any substantial implementation or review, run `python3 /mnt/d/workspace/VisualStudio/Libraries/Scripts/audit_gate.py --changed` from the active repo (or `python ...` on Windows).
- If you already know the touched files, run `python3 /mnt/d/workspace/VisualStudio/Libraries/Scripts/audit_gate.py <path1> <path2> ...` instead.
- Use the returned prompt list as the minimum required audit set for the current change scope.
- In every substantial implementation/review response, explicitly list the audit prompt files you applied.
## CRITICAL: Audit Prompt Compliance (Mandatory)
- Load the canonical index first: `/mnt/d/workspace/VisualStudio/Libraries/Scripts/audit_prompts/README.md`.
- Use the full prompt set directory as source of truth: `/mnt/d/workspace/VisualStudio/Libraries/Scripts/audit_prompts/`.

### Baseline Audits (Always Apply)
- `02_architecture_principles.md`.
- `03_defensive_programming_violations.md`.
- `05_security_patterns.md`.
- `06_logger_patterns.md` (especially Rule 5: static `warning/error` + dynamic `debug` details).
- `19_path_and_structure_audit.md`.
- `26_techstack_consistency.md`.

### Change-Type Audits (Apply When Relevant)
- Backend Python/FastAPI/Tkinter: `04_interface_validation.md`, `07_async_patterns.md`, `12_testing_standards.md`, `17_redis_backup_audit.md`, `18_redis_storage_consistency.md`, `20_url_endpoint_audit.md`, `25_shutdown_reason_tracking.md`.
- Bash/Deployment/Startup scripts: `21_bash_script_consistency.md`, `22_deployment_script_consistency.md`.
- Frontend/UI work: `14_frontend_visuals_and_mobile_standards.md`, `16_language_quality_no_ai_tone.md`.
- Docs/Marketing/Legal text: `13_documentation_audit.md`, `15_marketing_claims_and_conversion_audit.md`, `27_legal_compliance_audit.md`, `28_prompt_scope_cleanup.md`.
- Payments/Email workflows: `23_payment_integration_audit.md`, `24_email_services_audit.md`.
- Additional domain prompts when touched: `01_code_redundancies.md`, `08_enum_signal_patterns.md`, `09_codebase_cleanup.md`, `10_complexity_analysis.md`, `11_naming_and_comment_standards.md`.

### Mandatory Execution Rule
- In every substantial implementation/review response, explicitly list the audit prompt files applied.
- If a prompt is not applicable, state why it is out of scope.
