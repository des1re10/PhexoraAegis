# Phexora Aegis

**Open post-quantum privacy and scalability research by Phexora AI**

[![Website](https://img.shields.io/badge/Website-aegis.phexora.ai-6366f1)](https://aegis.phexora.ai)
[![Research text: CC0 1.0](https://img.shields.io/badge/Research%20text-CC0--1.0-success)](LICENSE)

## What Phexora Aegis is

Phexora Aegis is a research program for a private note-based DAG protocol. A
releasable design must satisfy five requirements together:

- **post-quantum security:** at least 128 bits of composed post-quantum security
  across every security-critical layer, without classical fallbacks;
- **privacy and network anonymity by default:** no transparent transfer mode,
  with sender, recipient, amount, graph relationship, and origin metadata
  protected within a published threat model;
- **scalability:** at least 1,000 accepted layer-1 transactions per second in a
  reproducible end-to-end test with all privacy and validation work enabled;
- **independent operability and recovery:** executing validation, restart,
  pruning, bootstrap, and recovery remain inside a frozen, independently
  obtainable resource profile without a trusted sole provider;
- **contestable production and reviewed long-run security funding:** pooled
  miners can construct their own templates, ordering/censorship incentives pass
  explicit gates, and the exact monetary policy has independently reviewed
  accounting and economic evidence.

These are release requirements, not achieved capabilities.

The initial product boundary is a private post-quantum cash and settlement
layer for people, organisations, and autonomous software agents. It targets
native-QTM transfers, user-controlled selective disclosure, and a finite set of
proof-bounded payment policies—not a general-purpose smart-contract platform.
Private assets, bridges, and cross-chain execution require later, separately
reviewed profiles and do not inherit the base protocol's claims.

## Current status

**Research design 0.5.4-research — not implementation-ready or production-safe.**

This repository currently contains a static documentation website, a research
design, a verification plan, and a transaction-feasibility pre-registration
draft. It does not contain a node, wallet, blockchain
implementation, testnet, external security audit, or completed performance
benchmark.

| Area | Status |
|---|---|
| SHAKE256 and ML-KEM-1024 | Standards selected; integration not verified |
| Spend authorization | FIPS 205 SLH-DSA-SHAKE-256f incumbent and required 256s comparator; comparative gate open |
| Lattice commitment | Blocking research gate |
| STARK validity proof | Blocking research gate |
| Complete 2-input/2-output transaction proof | Experiment specified; implementation and result absent |
| Receiving, offline catch-up and transport costs | Early T006 screen specified before T305; not run |
| GHOSTDAG and private state ordering | Blocking research gate |
| Validator operability | Blocking research gate; no numeric profile frozen |
| Current data, snapshots, and recovery | Blocking research gate |
| Miner templates, pools, and ordering incentives | Blocking research gate |
| PoW hardware contestability | Comparative research gate; algorithm not selected |
| Post-quantum upgrade governance | Blocking research gate; authorisation and activation mechanism not selected |
| Monetary security | Current 21M lifetime issuance cap retained; bounded dynamic-fee/reward-window comparator drafted; T506/G13 not run |
| Network anonymity | Blocking research gate |
| ≥1,000 accepted L1 TPS | Acceptance target; not yet benchmarked |

The project must stop before production if any of the five core requirements
cannot be demonstrated.

## Publication identity

Phexora Aegis is the current programme name. The already released 0.5.4-research
paper set and its generated PDFs retain the historical project codename
`Quantum` in filenames and publication text so the published revision remains
reproducible. A future paper revision may adopt the Aegis publication name only
together with regenerated PDFs, updated checksums, and the normal research
review gates. The historical codename is not the current product or programme
name.

## Research documents

- [Research design specification](papers/zkprivacy/zkprivacy-quantum-spec-v1.md)
- [Implementation and verification plan](papers/zkprivacy/zkprivacy-verification-guide.md)
- [Private-transaction STARK feasibility protocol](papers/zkprivacy/quantum-private-transaction-feasibility.md)
- [T305 prior-art and reuse decision](papers/zkprivacy/decisions/t305-prior-art-decision.md)
- [Decentralisation, operability, and security-budget decision](papers/zkprivacy/decisions/decentralisation-operability-security-budget-decision.md)
- [Market and claim thesis](Documentation/Phexora_Aegis_Market_Thesis.html)
- [Static-site system architecture](Documentation/SystemArchitecture.html)

The specification filename retains “v1” for link compatibility. The normative
revision is declared inside the document.

## Research-paper programme

Four separate manuscripts are planned because the problems have different
adversaries, evidence, and stop/go decisions:

| Order | Research question | Status |
|---:|---|---|
| 1 | Does full in-proof FIPS 205 SLH-DSA-SHAKE-256f or 256s provide a material benefit over one-time/stateful hash-based baselines while the same complete 2-input/2-output relation meets frozen security and client budgets? | Active comparative research protocol 0.4.0; no result |
| 2 | Can wallets discover post-quantum encrypted notes privately at the measured output rate? | [Template](papers/zkprivacy/templates/private-note-discovery-template.md) |
| 3 | Can transaction origins remain hidden under a named observer model at BlockDAG throughput? | [Template](papers/zkprivacy/templates/network-origin-anonymity-template.md) |
| 4 | Can GHOSTDAG apply private commitments, nullifiers, anchors, rewards, and reorganisations deterministically? | [Template](papers/zkprivacy/templates/ghostdag-private-state-template.md) |

The programme does not claim that these broad areas are new. TzEL already
publishes an experimental note/nullifier/ML-KEM/one-time-authorisation/STARK
payment path, while Lattice RingCT, MatRiCT/MatRiCT+, LACT+, private payment
detection and retrieval, cryptocurrency network-origin anonymity, and
GHOSTDAG cover further major subproblems. Paper 1 is therefore a comparative
feasibility and standardisation study, not a new private-payment-protocol
claim. The
[versioned prior-art decision](papers/zkprivacy/decisions/t305-prior-art-decision.md)
records the adopt/adapt/replicate boundary. Each later manuscript must likewise
state and independently review its narrower contribution. The
[template index](papers/zkprivacy/templates/README.md) defines when a template
may become an active paper.

## Candidate protocol directions

| Responsibility | Candidate direction | Evidence boundary |
|---|---|---|
| Hash/XOF | SHAKE256, NIST FIPS 202 | Standard selected |
| Authorization | Stateless incumbent: SLH-DSA-SHAKE-256f; required 256s comparator; stateful comparators: independently specified one-time tree and applicable NIST SP 800-208 profile | Same-relation cost, state-failure model, and separate material-benefit decisions open |
| Key encapsulation | ML-KEM-1024, NIST FIPS 203 | Authenticated composition open |
| Validity proof | Transparent STARK | Exact AIR/FRI/ZK profile open |
| Note commitment | Reviewed lattice construction | Construction and parameters open |
| Consensus | Versioned GHOSTDAG-based PoW profile | State ordering, DAA and finality open |
| Origin privacy | Dedicated anonymous transport layer | Protocol and analysis open |
| Validator operability | Versioned profile frozen before result interpretation | Exact ceilings and G7/G10 evidence open |
| State validity/bootstrap | Authenticated checkpoint/replay; accumulated proof only if T306 selects it | Validity, current data, wallet witnesses, and recovery remain separate |
| Current data/recovery | Complete current data for executing validators plus authenticated multi-provider recovery | Encoding, reconstruction, repair, retention, withholding, and eclipse gates open |
| Block templates | Miner-controlled Template Provider/Job Declarator | Pool protocol, private payouts, adoption and overhead gate open |
| Ordering/incentives | Candidate comparison under the exact public fields and DAG rules | No MEV-free claim; fee, conflict, timing, censorship and reorg gate open |
| Monetary policy | Current 21M lifetime gross-issuance cap with bounded dynamic-fee/reward-window comparator | Exact controller parameters, allocation, schedule and long-run security evidence open |
| PoW hardware | Candidate selected only after contestability study | No ASIC-resistance claim; algorithm open |
| Upgrade governance | Versioned post-quantum authorisation and deterministic activation | T510 mechanism, key lifecycle, compromise recovery, and emergency path open |
| Selective disclosure | Incoming, full-wallet, transaction, and auditor-scoped capabilities | Construction and scope proofs open |
| Payment logic | Finite registry of bounded private payment policies | Post-core profile; no general VM |

Selecting a standardized primitive does not prove the security, anonymity, or
performance of the composed protocol.

## Local documentation site

The checked-in website can be opened directly from a standalone clone without
starting a runtime:

~~~bash
git clone https://github.com/des1re10/PhexoraAegis.git PhexoraAegis
cd PhexoraAegis
# Open index.html in a browser
~~~

The public interface supports English and German through the header language
switcher. The selected language is preserved in local navigation through the
<code>?lang=en</code> or <code>?lang=de</code> query parameter; no server
runtime or external translation service is required. The company footer follows
the shared Phexora AI footer contract, while privacy, terms, imprint, and refund
policy remain at their canonical <code>phexora.ai</code> destinations.

The validated HTTP preview is a development-workspace command. From a complete
<code>VisualStudio</code> workspace containing the sibling
<code>Libraries</code> repository, run:

~~~bash
cd PhexoraAegis
./start-local.sh
# Open http://127.0.0.1:9180
~~~

On Windows, use <code>start-local.bat</code>. When no port is supplied, both
launchers resolve it through the shared application registry; the Windows
launcher additionally uses the shared startup helper. Required workspace
dependencies fail closed, selected ports are validated, and both servers bind
to <code>127.0.0.1</code>. The launchers also verify that generated paper PDFs
are current; rebuilding them requires the sibling <code>DocWizard-Pro</code>
repository.

## PDF generation

Root-level Markdown files in <code>papers/zkprivacy/</code> are the
authoritative active-paper sources. Same-name PDF files are generated through
the adjacent DocWizard-Pro repository:

~~~bash
./build-pdfs.sh
# On Windows: build-pdfs.bat
~~~

All active-paper PDFs must be regenerated after material paper changes.
Planning files under <code>papers/zkprivacy/templates/</code> and decision
records under <code>papers/zkprivacy/decisions/</code> are deliberately
excluded from the PDF build and are not presented as completed papers.

The papers select DocWizard's `scientific` style in their front matter. Their
section titles already contain normative numbers, so the build deliberately
does not add DocWizard's automatic section numbering.

The build scripts use the adjacent DocWizard-Pro repository's prepared
`.venv` runtime and fail if that exact runtime, Pandoc, or XeLaTeX is missing.

## Contributing

Useful contributions include:

- corrections to the threat model or validity relation;
- concrete, cited commitment or STARK analyses;
- reproducible complete-transaction proving and aggregation benchmarks;
- deterministic GHOSTDAG/state-ordering models;
- anonymous-network threat analysis;
- independent implementations and interoperability vectors;
- reproducible performance and storage budgets.

Do not describe an open gate as verified. Cryptographic, consensus, anonymity,
and release approvals require independent human specialist review.

## License and legal boundary

Repository-authored research text and documentation are dedicated under
[CC0 1.0 Universal](LICENSE). That dedication does not cover repository scripts,
styles, company or product identifiers, or third-party material unless a
separate notice says otherwise. CC0 does not grant patent or trademark rights.

This research is not legal, tax, financial, or investment advice and is not an
offer to sell a token, security, or network service.
