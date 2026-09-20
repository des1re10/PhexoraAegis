# Project Structure

*Last Updated: August 2026*

```
PhexoraAegis/
├── CLAUDE.md                         # Development guidelines for Claude Code
├── AGENTS.md                         # Agent instructions (local start commands)
├── README.md                         # Project overview and quick start
├── LICENSE                           # CC0 dedication and rights boundary
├── index.html                        # Landing page plus generated consent analytics
├── .gitignore                        # Git ignore rules
│
├── Documentation/
│   ├── ProjectStructure.md           # This file
│   ├── SystemArchitecture.html       # System design and deployment
│   ├── InvestorOnePager.html         # Evidence-based research brief
│   ├── Phexora_Aegis_Market_Thesis.html    # Market and claim thesis
│   ├── assets/
│   │   └── documentation.css         # Shared internal-document styles
│   └── ReleaseNotes.md               # Version history
│
├── papers/                           # Research papers and specifications
│   └── zkprivacy/                    # Phexora Aegis: Privacy-Preserving DAG Blockchain
│       ├── quantum-private-transaction-feasibility.md  # 0.4.0 active T305 research protocol
│       ├── quantum-private-transaction-feasibility.pdf # Generated PDF export
│       ├── zkprivacy-quantum-spec-v1.md      # 0.5.4 research design and requirements
│       ├── zkprivacy-quantum-spec-v1.pdf     # PDF export
│       ├── zkprivacy-verification-guide.md   # 0.5.4 implementation and evidence plan
│       ├── zkprivacy-verification-guide.pdf  # PDF export
│       ├── decisions/                         # Versioned research gates; not papers
│       │   ├── t305-prior-art-decision.md     # Adopt/adapt/replicate and reuse boundary
│       │   └── decentralisation-operability-security-budget-decision.md
│       │                                      # R9-R12/G10-G13 research boundary
│       └── templates/                         # Future-paper plans; not active papers
│           ├── README.md                      # Four-paper programme and promotion gate
│           ├── private-note-discovery-template.md
│           ├── network-origin-anonymity-template.md
│           └── ghostdag-private-state-template.md
│
├── assets/
│   ├── css/
│   │   └── style.css                 # Main stylesheet
│   ├── js/
│   │   └── site-i18n.js              # Single DE/EN landing-page locale contract
│   └── images/
│       └── favicon.svg               # Site favicon
│
├── tools/
│   └── Scripts/
│       ├── Startup/                  # Deployment and startup scripts
│       │   ├── phexora_aegis_deploy_script.sh  # Deploy from pCloud to server
│       │   └── run_phexora_aegis.sh            # Nginx/SSL configuration
│       └── deploy_testing.bat        # Windows deployment to pCloud
│
├── build-pdfs.sh                     # PDF generation (Linux)
├── build-pdfs.bat                    # PDF generation (Windows)
├── start-local.sh                    # Local dev server (Linux)
├── start-local.bat                   # Local dev server (Windows)
├── deploy_testing.bat.lnk            # Shortcut to deploy script
└── converter.log                     # PDF converter log (generated)
```

## PDF build contract

- Root-level Markdown files in `papers/zkprivacy/` are the authoritative active
  publication sources; same-name PDFs are generated artifacts.
- Active sources select DocWizard's `scientific` style in YAML front matter.
  The normative specification and verification guide retain their explicit
  section numbers.
- Markdown outlines under `papers/zkprivacy/templates/` are planning artifacts.
  They are excluded from the PDF build and public completed-paper list.
- Markdown records under `papers/zkprivacy/decisions/` are research and reuse
  gates. They are linked evidence, not active papers, and are excluded from the
  PDF build.
- `build-pdfs.sh` and `build-pdfs.bat` require the adjacent DocWizard-Pro
  repository's prepared `.venv` runtime and invoke its canonical
  `Src/universal_converter.py` entry point. Both scripts discover active
  root-level Markdown sources instead of maintaining a duplicated paper list.

## Production measurement

- `aegis.phexora.ai` owns a dedicated SiteBuilder analytics identity and
  exact allowed origin; it is not grouped with another static website.
- The SiteBuilder-generated runtime remains off until explicit analytics
  consent and records page views plus named research-document CTAs without
  form contents.
- Aggregate reports are linked to the internal BusinessPlanner workspace.

## Production publication

The repository deployment keeps `/var/www/phexora-aegis` as the registered restore
source. Production Nginx serves the stable SiteBuilder domain alias
`runtime/main/publication-domains/aegis.phexora.ai`; SiteBuilder atomically
moves that alias to the deployment of the currently assigned site when its
owner or a publisher selects Publish. TEST remains repository-owned at
`/var/www/phexora-aegis-test`.
