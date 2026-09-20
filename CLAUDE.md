# CLAUDE.md — Phexora Aegis

## Scope

Phexora Aegis is a static documentation website and research-paper repository. It
does not currently contain a blockchain, node, wallet, API, backend, database,
or frontend framework.

Read and follow [AGENTS.md](AGENTS.md) before work. It owns the audit workflow,
required prompts, local start commands, and fail-fast policy; those rules are
not duplicated here.

## Research status

The current protocol document is revision <code>0.5.4-research</code>, even
though its legacy filename contains “v1”.

The five non-negotiable release requirements are:

1. ≥128-bit composed post-quantum security without classical fallbacks;
2. private transfers and network anonymity by default, with no transparent
   transaction mode;
3. ≥1,000 accepted layer-1 transactions per second in a reproducible,
   privacy-enabled end-to-end benchmark;
4. independently bounded executing validation and recovery without a trusted
   sole provider; and
5. contestable block production with explicitly reviewed ordering incentives
   and long-run security funding.

These are targets. Never describe them as achieved until the matching evidence
gates in the specification and verification plan pass.

The initial product boundary is private post-quantum cash and settlement with
selective disclosure and a finite set of bounded payment policies. General
smart contracts, private assets, bridges, and cross-chain execution are
separate later profiles and do not inherit base-protocol claims.

## Canonical files

| Responsibility | Owner |
|---|---|
| Protocol requirements and candidate design | <code>papers/zkprivacy/zkprivacy-quantum-spec-v1.md</code> |
| Task graph and evidence gates | <code>papers/zkprivacy/zkprivacy-verification-guide.md</code> |
| T305 research protocol and prior-work boundary | <code>papers/zkprivacy/quantum-private-transaction-feasibility.md</code> |
| T305 adopt/adapt/replicate and source-reuse decision | <code>papers/zkprivacy/decisions/t305-prior-art-decision.md</code> |
| Operability, availability, producer, and security-budget decision | <code>papers/zkprivacy/decisions/decentralisation-operability-security-budget-decision.md</code> |
| Future-paper scope and promotion gates | <code>papers/zkprivacy/templates/</code> |
| Public research positioning | <code>index.html</code> and <code>README.md</code> |
| Market/claim wording | <code>Documentation/Phexora_Aegis_Market_Thesis.html</code> |
| Actual static-site architecture | <code>Documentation/SystemArchitecture.html</code> |
| Public site styles | <code>assets/css/style.css</code> |
| Public DE/EN locale contract and language switching | <code>assets/js/site-i18n.js</code> |
| Company-footer structure and legal URLs | <code>../Libraries/frontend/components/Company/Footer.jsx</code> and <code>../Libraries/frontend/components/Company/companyLinks.js</code> |
| Internal document styles | <code>Documentation/assets/documentation.css</code> |

Root-level Markdown papers in <code>papers/zkprivacy/</code> are active source
documents. Their same-name PDFs are generated artifacts and must be rebuilt
after material changes. Markdown files under
<code>papers/zkprivacy/templates/</code> are planning artifacts, are excluded
from the PDF build, and must not be presented as completed papers or results.
Markdown files under <code>papers/zkprivacy/decisions/</code> are versioned
research gates rather than active manuscripts and are also excluded from the
PDF build.

## Technology and structure

~~~text
PhexoraAegis/
├── index.html
├── assets/
├── papers/zkprivacy/
├── Documentation/
├── tools/Scripts/
├── build-pdfs.sh
├── build-pdfs.bat
├── start-local.sh
└── start-local.bat
~~~

- Runtime: static HTML/CSS/JavaScript served by Nginx.
- Local preview: port 9180 through the repository start scripts.
- PDF build: Markdown → DocWizard-Pro/Pandoc → PDF.
- Deployment: <code>tools/Scripts/deploy_testing.bat</code> on Windows, then
  <code>tools/Scripts/Startup/phexora_aegis_deploy_script.sh</code> on the server.
- Server deployment uses the shared script infrastructure as tooling but
  publishes only Phexora Aegis; the registry marks this static site as a non-consumer
  of the shared Libraries payload.
- AppManager or the central orchestrator passes the exact bundle-staged
  `Libraries/Scripts` owner directory; manual runs use the canonical
  `~/AppManager/Libraries/Scripts` installation.
- Missing sudo, missing startup tooling, or web-root content that differs from
  the staged Phexora Aegis payload is a deployment failure.
- Public web root: <code>index.html</code>, <code>LICENSE</code>,
  <code>assets/</code>, and <code>papers/</code>. <code>Documentation/</code> is not
  deployed publicly.

## Editing rules

- Prefer technical accuracy and explicit evidence status over promotional
  language.
- Use FIPS 205 terminology <strong>SLH-DSA</strong>; SPHINCS+ is only design
  lineage.
- Do not invent cryptographic constructions, parameter security, Noise
  patterns, test vectors, benchmarks, or audit results.
- Do not claim that post-quantum private payments, RingCT, STARK-based
  hash-signature aggregation, private note retrieval, transaction-origin
  anonymity, or GHOSTDAG ordering are new. In particular, the scoped current
  review identifies TzEL as its closest public
  note/nullifier/ML-KEM/one-time-authorisation/STARK baseline, and LACT+ is an
  aggregation/confidential-value comparator. The active feasibility paper and
  versioned T305 decision own the current prior-work boundary.
- Distinguish requirements, selected standards, candidates, open gates, and
  verified results.
- Keep executing-validator, succinct-verifier, producer, prover, state-provider,
  archive-provider, and pool/share-aggregator claims distinct.
- Never treat proof soundness as current-data availability, archive recovery,
  censorship resistance, or wallet-witness availability.
- Do not change the 21,000,000 QTM lifetime gross-issuance statement without
  the exact versioned Product Owner, monetary-economics, consensus, and legal
  approvals required by R12/T506.
- A generic STARK, lattice commitment, or PQ primitive does not establish
  composed protocol security.
- Keep HTML semantic, responsive, and accessible. Client-side JavaScript is
  limited to the documented shared DE/EN locale contract unless another
  requirement is approved explicitly.
- Use external stylesheets; do not add page-specific inline style blocks.
- Update <code>Documentation/ReleaseNotes.md</code> and
  <code>Documentation/ProjectStructure.md</code> when structure or durable
  behavior changes.

## Validation

For documentation changes:

1. run the audit gate required by <code>AGENTS.md</code>;
2. parse Markdown with Pandoc;
3. parse or validate HTML, verify both locales, and check local links/assets;
4. rebuild every active-paper PDF;
5. review public claims across README, landing page, papers, and research
   briefs;
6. run <code>git diff --check</code>.
