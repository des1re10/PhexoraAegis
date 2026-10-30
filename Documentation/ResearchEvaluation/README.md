# Early receive/transport screen — 2026-10-30

Internal exploratory supplement. The current specification, verification guide,
T006 receive/discovery gate and T305 private-transaction protocol retain their
authority. This tool changes none of their requirements, security parameters,
approval states or publication PDFs. No cryptography, node, network or proving
experiment was run.

## Result and stop decision

The declared uncompressed full-scan profile is ruled out for a 10 Mbit/s link,
50 decimal GB historical-download allowance and one day offline at 1,000 accepted
transactions/second with two ML-KEM-1024 encapsulations per transaction.

[FIPS 203, Table 3](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.203.pdf)
specifies a 1,568-byte ML-KEM-1024 ciphertext. This gives a ciphertext-only floor:

- 3,136 bytes/transaction;
- 25.088 Mbit/s continuously;
- 270.9504 GB/day;
- 50.176 Mbit/s to download one day of history within a day while also keeping up
  with live ciphertexts, with transport multiplier 1.

These are analytical values from the declared construction, not measured traffic
or a universal lower bound on all private/PQ payment designs. The selected link
and wallet budgets are exploratory assumptions, **not approved T005 thresholds**.
Proofs, payloads, commitments, nullifiers, headers, retries, cover traffic and
wallet scanning CPU only increase cost in this profile and are not included.

The screen can return `RULED_OUT_BY_LOWER_BOUND` or `UNRESOLVED`; it cannot pass
T006, T305 or any feasibility/security gate. A design that avoids full-history
download must document its separate privacy, availability and trust properties.

## Reproduce and inspect

From the Aegis repository root:

```bash
python3 tools/feasibility_screen.py \
  Documentation/ResearchEvaluation/receive_floor_config.json /tmp/new-receive-floor.json
python3 -m pytest tests/test_feasibility_screen.py -q
```

The retained `receive_floor_result.json` binds source and config SHA-256 hashes.
No existing output is overwritten. Mbit and GB are decimal units. Catch-up
includes the continuing live stream. Inputs must be finite and positive;
outputs/transaction must be an integer; transport multiplier cannot be below 1.

## Prior art and next allocation

[TzEL](https://tzel.tezos.com/) already presents an experimental post-quantum
private rollup. Generic PQ privacy is not a defensible novelty statement.
This project still needs its exact composed security review, construction and
an operable receive/transport design; primitive standardization does not certify
the composition.

Stop expansion of this full-scan profile under the declared budget. Before
prover implementation, a named receiving/network reviewer must examine a bounded
discovery/catch-up alternative and approve numeric T006 inputs. Only then revisit
the existing T305 protocol with independent cryptography/proof reviewers.
No enterprise performance or deployable blockchain pitch is justified. Keep
Aegis out of the initial inference partner brief.
