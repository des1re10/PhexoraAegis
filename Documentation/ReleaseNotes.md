# Phexora Aegis - Release Notes

## Unreleased

**Public metadata and link integrity — 2026-09-20**

- Added the canonical URL plus OpenGraph and Twitter card metadata to the
  landing page so shared links resolve to `https://aegis.phexora.ai/` and the
  preview reuses the existing DE/EN title and description keys.
- Repaired the market-and-claim-thesis link in `README.md`, which still pointed
  at the pre-Aegis `Documentation/Quantum_Market_Thesis.html` filename.
- Extended the `aegis-identity` workflow with a metadata and link-target check
  so a missing canonical tag or a dead local link fails CI.

**Research revision 0.5.4 — 2026-09-05**

- Advanced the specification and verification guide to 0.5.4-research and
  the comparative feasibility protocol to 0.4.0-research-protocol.
- Required independently spendable note instances across duplicate commitments,
  historical-note/nullifier continuity through upgrades, and wallet witness
  refresh and rollback after reorgs.
- Specified an acyclic encryption/effects-ID/authorisation/proof construction,
  separate proof carriage and pre-sign fee-context/weight contracts.
- Required exact contextual DAG acceptance and atomic rejection/rollback;
  added a symbolic merge/reorg example without claiming a consensus proof.
- Corrected semantic prerequisites in the 41-task graph and added T006 as an
  early receiving, offline catch-up and transport screen before T305.
- Added required FIPS 205 256s Arm D beside 256f and an explicitly exploratory,
  limited-use SP 800-230 draft boundary; each stateless arm must qualify separately.
- Added scenarios A039–A047, synchronized decision revisions 1.1/0.3.3,
  research templates and DE/EN summaries, and regenerated all three active PDFs.
- Reflowed the existing SHAKE256 wrapper vectors so every hexadecimal byte
  remains visible in the PDF; the independently recomputed values are unchanged.
- Kept all research gates and specialist approvals open. No implementation,
  benchmark, security proof or monetary-policy change is reported.

- Reduced the initial analytics choice to a compact bottom bar with equal
  necessary-only and consent actions, plus a footer settings control.
**Consent-based static-site measurement**

- Registered Phexora Aegis as its own SiteBuilder website analytics owner, restricted
  collection to the exact production origin, and linked aggregate reporting to
  BusinessPlanner.
- Installed the SiteBuilder-generated opt-in runtime and assigned stable CTA
  names to the research status, specification, verification plan, feasibility
  protocol, and GitHub contribution paths.

**Bounded Dynamic-Fee and Reward-Window Comparator**

- Advanced the specification and verification plan to
  <code>0.5.3-research</code> and the independently versioned decentralisation,
  operability, and security-budget decision to <code>0.3.2-research</code>.
- Retained the 21,000,000 QTM lifetime gross-issuance cap and added a bounded,
  non-oracle dynamic resource/security fee controller as a required T506/T508
  comparator. No controller parameter, fee schedule, reward allocation, or
  adequate-security result is selected.
- Required fee epochs and controller inputs to derive only from prior-finalised
  canonical DAG state with exact integer rounding, rate clamps, update lag, and
  an explicit zero-accepted-weight transition.
- Added an observable <code>UNDERFUNDED</code> result: missing transaction demand
  remains zero fee revenue and cannot authorise extra issuance, restore cap
  headroom, or be reported as adequate miner funding.
- Added a consensus fee-pool liability so delayed, unpaid miner-eligible fees
  remain in outstanding supply until deterministic payout or explicit burn;
  they do not become gross issuance or disappear implicitly.
- Separated accepted resource/security/priority fees from their miner-eligible,
  burn, and non-miner-output destinations. Sustainable miner budget now uses
  only newly miner-eligible fees, while payout capacity uses only matured
  claimable pool value.
- Required non-negative exact-width arithmetic, checked add/multiply/accumulate,
  quotient/remainder ceiling division, exactly-once canonical fee assignment
  across reorgs, and explicit genesis pool/controller state.
- Added direct payout, partial/full delayed pooling, partial payout plus burn,
  and resource/security split comparators plus permanent adversarial scenarios
  for omission, self-fees, accepted-weight manipulation, fee sniping, free-
  riding, censorship, reorganisation, and pool coordination.
- Required T506 to freeze the exact controller and payout/pool/burn rule before
  T504; a T508 rejection starts a new versioned campaign and rebuilds dependent
  evidence instead of changing the rule in place.
- Required T510 to classify immutable, normal-upgrade-only, and emergency-
  changeable parameters; emergency activation cannot alter protected monetary
  rules or erase accrued fee-pool liabilities.

**Operability, Availability, Producer, and Monetary-Security Gates**

- Advanced the specification and verification plan to
  <code>0.5.2-research</code> while retaining their existing canonical paths and
  generated-PDF contract.
- Added independent operability/recovery and producer-contestability/economic-
  review properties to the five-part release boundary. None is an achieved
  capability.
- Added R9-R12 and Gates G10-G13 for a frozen executing-validator profile,
  complete current data and no-trusted-sole-provider recovery,
  miner-controlled templates and transaction-selection incentives, and an
  exact product-owned monetary-security decision.
- Expanded the verification graph from 31 to 40 acyclic tasks with T005, T306,
  T505-T510, and T605. PoW hardware contestability now precedes algorithm
  selection; monetary analysis precedes reward implementation; T510 owns post-
  quantum upgrade authorisation and deterministic activation; data availability
  remains outside proof soundness.
- Kept recursion, witness-carrying state, recovery coding, ordering rules,
  pooled-mining mechanisms, PoW, and replacement monetary policies as
  candidates. No numeric operability profile was invented.
- Made 256-bit BIP-39 the minimum compatibility profile while requiring T001
  and T204 to derive the complete wallet master-secret entropy from the approved
  multi-user, multi-target, and lifetime bound. Lower-entropy legacy imports
  remain explicitly degraded and do not inherit the full claim.
- Separated generic proof-system accumulation capability in T306 from the exact
  Phexora Aegis consensus/state relation in T505, made T405 a dependency for its
  policy-state semantics, and removed performance-threshold ownership from the
  T104 commitment-security decision.
- Added governance-capture, client-distribution, and voluntary-social-adoption
  boundaries to T510 without presenting deterministic upgrade activation as
  governance decentralisation.
- Required digest-only encrypted note carriage to report external payload
  bytes, total payment bytes, provider/retrieval traffic, and retention
  assumptions separately from consensus bytes.
- Required G12 and G13 metrics, scenarios, pass/fail thresholds, and STOP
  conditions to be registered before candidate results are interpreted.
- Corrected monetary accounting to distinguish claimed fees, claimed and
  foregone subsidy, burned existing value, gross issuance, and outstanding
  supply. The current 21,000,000 QTM lifetime gross-issuance cap remains in
  force pending a separately signed product, economics, consensus, and legal
  decision.
- Added the versioned decentralisation, operability, and security-budget
  decision with primary-source boundaries for GHOSTDAG transaction-selection
  incentives, Kaspa sequencing commitments, Stratum V2 Job Declaration,
  Utreexo, data availability, and fee-funded PoW security.
- Added the new decision record to the required public-paper contract and made
  deployment fail before activation if any declared public Markdown paper is
  missing from either the staged target or the web root.
- Advanced the transaction-feasibility protocol to
  <code>0.3.2-research-protocol</code>: T004 now owns the benchmark method,
  harness, and pinned environment, while T005 owns every numerical acceptance
  threshold. No measurement or feasibility result is reported.

**Prior-Art Decision and Comparative Authorization Gate**

- Added a versioned T305 prior-art and reuse decision. The scoped review
  identifies TzEL as its closest public engineering baseline, rejects a generic
  post-quantum private payment novelty claim, and records an ADAPT + REPLICATE
  path. Named owner and reviewer signatures remain required before
  implementation.
- Documented Lattice RingCT, MatRiCT/MatRiCT+, Gao et al., LACT+, TzEL, NIST
  SP 800-208, and the non-final SP 800-230 draft as explicit comparison
  boundaries.
- Reframed Paper 1 as a same-relation comparison between the FIPS 205
  <code>SLH-DSA-SHAKE-256f</code> stateless incumbent, an independently
  specified TzEL-shaped one-time baseline, and an applicable NIST stateful
  profile.
- Added state-management failure cases, a requirement to pre-register the
  material-benefit rule, source-licence restrictions, and
  GO/ADAPT/REPLICATE/STOP outcomes.
- Advanced the specification and verification guide to
  <code>0.4.0-research</code> and synchronized public and internal status
  surfaces. The architecture decision is evidence for Paper 1, not a fifth
  paper.

**Landing Page and Local Preview**

- Reworked the landing page around a concise research-programme sequence, three
  design principles, an explicit publication order, and a contribution path.
  Design targets are presented as the target architecture, repeated research
  copy and duplicate legal navigation were removed, and the mobile layout was
  shortened.
- Reframed public copy around Phexora Aegis's vision, design principles, and research
  progress while retaining detailed uncertainty, prior-art, and stop/go
  analysis in the linked research documents.
- Added consistent keyboard focus treatment, reduced-motion handling, and
  non-interactive publication cards.
- Added one shared DE/EN locale contract for the landing page, with an
  accessible language switcher in desktop and mobile navigation.
- Added a static projection of the shared Phexora AI company-footer contract,
  linked every legal destination to its canonical Phexora AI owner, removed the
  three duplicate local legal pages, and raised footer link targets to at least
  44 pixels.
- Added a dependency-free direct-file path for standalone clones and documented
  the shared workspace dependencies required by the validated HTTP preview.
- Made the Linux preview resolve its required registry contract without a
  hidden port fallback, reject malformed or out-of-range explicit ports
  before PDF checks, bind only to <code>127.0.0.1</code>, and preserve startup
  failures. The Windows launcher now reports the same loopback URL it binds.
- Aligned server publication with Phexora Aegis's registry-owned static-site
  boundary: the wrapper uses shared deployment helpers but stages only the
  Phexora Aegis payload and no longer requires or deploys a Libraries payload.
- Server publication now receives one canonical bundle-staged shared-tooling
  directory, fails closed when non-interactive sudo is unavailable, verifies
  every web-root file/directory against the staged app, and emits the standard
  deployment summary used by AppManager.

**Research Publication Programme**

- Added a T305 pre-registration draft for the complete 2-input/2-output
  private-transaction STARK feasibility experiment. It reports no
  implementation, benchmark, proof, or feasibility result.
- Documented the prior-work boundary against Lattice RingCT, MatRiCT and
  MatRiCT+, STARK-based hash-signature aggregation, private note retrieval,
  network-origin anonymity, and GHOSTDAG research.
- Split the remaining research into three templates: private note discovery,
  network-origin anonymity, and deterministic GHOSTDAG private-state semantics.
- Defined a four-manuscript programme and explicit promotion gates so templates
  cannot be presented as completed papers.
- Updated Linux and Windows PDF builders to discover every active root-level
  Markdown paper while excluding the template directory.
- Updated both local-preview launchers to detect a missing or stale PDF for any
  active root-level paper instead of checking a hard-coded pair, and to fail
  closed instead of serving a preview with missing or outdated publications.
- Synchronized the landing page, README, architecture, market thesis, project
  structure, and contributor guidance with the new publication contract.

## Version History

### v1.0.0 (2026-01-14)

**Initial Release**

- Created project structure for post-quantum cryptography research
- Added Phexora Aegis specification:
  - `zkprivacy-quantum-spec-v1.md` - Full specification for privacy-preserving DAG blockchain
  - `zkprivacy-verification-guide.md` - AI implementation and verification guide
- Landing page with paper listing
- Responsive design with light academic theme

**Papers Included:**
- Phexora Aegis: Privacy-Preserving DAG Blockchain (Draft v1.0)

### v1.1.0 (2026-01-16)

**Major Architecture Update: DAG-Native Design**

- Renamed ZKPrivacy to Phexora Aegis
- Adopted GhostDAG consensus as core architecture (1,000+ TPS target)
- Added comprehensive documentation:
  - Abstract, Introduction, Design Philosophy sections
  - Project Status and Research Phases with milestones
  - Alternative scaling approaches comparison (Leios, Sharding, Solana)
  - Core research challenges (privacy-preserving DAG proofs)
  - Bitcoin foundations: UTXO model, Nakamoto consensus, fair launch
- Updated requirements (R8: Scalability) for DAG-native design
- Updated landing page with research project positioning
- Added honest assessment of proven vs unproven components
- Emphasized fair launch model (no premine, no ICO, no founder's reward)

### v1.2.0 (2026-06-11)

**Specification Soundness Revision (Draft; superseded by v1.3.0)**

The entries below record the intent of that historical draft. They are not
current conformance or security evidence; v1.3.0 withdrew the unsupported
constructions and claims.

- Fixed emission schedule: defined for the DAG block rate (0.01 QTM initial
  reward, 1.05B-block halving interval, ~66-year emission), reward formula
  now in satoshi; the previous Bitcoin-copied schedule would have emitted
  the full supply within days and summed to only 20.37M QTM
- Fixed value encoding: amounts committed as 4×16-bit limbs (a single
  coefficient mod q ≈ 2^23 silently wrapped amounts above ~0.08 QTM)
- Closed spend-authority gap: note commitments now bind the recipient's
  SpendPK hash and NullifierPK; spend authorization (now standardized as
  SLH-DSA) over sighash
  is verified in-circuit, so a note's creator can no longer re-spend or
  re-nullify it; on-chain signatures removed (~110 KB transactions, down
  from ~205 KB)
- Proposed an ML-KEM transport direction; v1.3.0 later withdrew the unsupported
  custom Noise-pattern claim and made exact authenticated composition a gate
- Removed fabricated test vectors; v1.3.0 replaces placeholders with a
  reproducible evidence plan and checked domain-wrapper vectors
- Reconciled performance/hardware requirements (R6.1/R6.2 vs Section 19.2
  vs Appendix G.1); batch proof verification required at target throughput
- Fixed difficulty-adjustment direction, FRI parameter/security mismatch,
  genesis difficulty estimate, address encoding (Bech32m unusable at
  1.6 KB payloads), range-check constraint degree, and size/fee figures
- Verification guide aligned with all spec changes; acceptance-criteria
  checkboxes unchecked (no implementation exists yet)
- Documentation: ProjectStructure.md brought up to date;
  SystemArchitecture.html Markdown conversion artifacts fixed

### v1.3.0 (2026-07-09)

**Research Design and Evidence-Gate Revision**

- Reclassified the protocol as research design <code>0.2.0-research</code>;
  removed unsupported “specification complete,” achieved security, anonymity,
  and throughput claims
- Kept post-quantum security, anonymity by default, and at least 1,000 accepted
  L1 TPS as hard, joint release requirements
- Closed the specification-level inflation gap: proofs must bind every input
  and output value to a commitment opening and enforce balance with bounded
  integer limbs and carries
- Withdrew the unsupported commitment formula, biased sampler, incomplete
  STARK security calculation, self-declared PoW target, wall-clock/float DAA,
  and ambiguous DAG reward/genesis rules
- Updated standardized terminology to FIPS 205 SLH-DSA and made authenticated
  ML-KEM transport plus network anonymity separate blocking gates
- Replaced autonomous-AI implementation guidance with a human-owned,
  29-task verification plan, independent review, honest NOT_STARTED reports,
  and reproducible evidence requirements
- Migrated the market thesis to durable HTML, centralized internal document
  styling, and corrected static-site build/deployment boundaries
- Aligned README, landing page, research brief, structure documentation, and
  legal/CC0 wording with the actual evidence state
- Added explicit gates for quantum digest-length analysis and recipient-key
  privacy in encrypted note delivery
- Defined fee transfer, subsidy issuance, burn, reward-maturity, and supply-cap
  accounting as one consensus invariant
- Included the research license in staging and public deployment, fixed narrow
  navigation, and removed duplicated or stale documentation structures

### v1.3.1 (2026-07-22)

**Private Settlement Research and Publication Revision**

- Advanced both papers to research design <code>0.3.0-research</code> and
  narrowed the initial product boundary to private post-quantum cash and
  settlement rather than a general-purpose smart-contract platform.
- Added the Phexora AI author URL to both paper title pages and PDF metadata
  sources.
- Added a mandatory, complete 2-input/2-output proof feasibility gate before
  wallet, node, or GHOSTDAG integration, with separate client-latency,
  verifier, wire-size, memory, parallel-prover, and aggregation budgets.
- Defined least-privilege incoming, full-wallet, transaction-specific, and
  auditor-scoped disclosure capabilities without a universal viewing key.
- Added a finite, proof-bounded payment-policy direction and separated private
  assets and cross-chain adapters into later profiles with their own trust and
  claim boundaries.
- Expanded the verification plan from 29 to 31 tasks with T305 and T405, added
  adversarial disclosure/policy cases, and synchronized the landing page,
  README, market thesis, and research brief.
- Switched both research papers to DocWizard's scientific-manuscript style,
  added publication metadata, abstracts, keywords, and a proper document
  heading hierarchy, and removed the duplicated rendered title/status block.
- Regenerated both PDF artifacts through the canonical DocWizard/Pandoc/XeLaTeX
  pipeline.
- Hardened Windows preview startup, normalized launcher line endings, and
  aligned deployment wrappers with the shared publication contract.
- Release packaging update: annotated repository tag advanced to `v1.3.1`.
