"""Exploratory receive/transport floor; cannot certify T006 or T305 feasibility."""

import argparse
import hashlib
import json
import math
from pathlib import Path


def positive(value, name):
    if type(value) not in (int, float) or not math.isfinite(value) or value <= 0:
        raise ValueError(f"{name} must be finite and positive")
    return value


def screen(config: dict) -> dict:
    if config["schema_version"] != 1 or config["status"] != "exploratory":
        raise ValueError("only exploratory schema 1 is supported")
    tps = positive(config["accepted_tps"], "accepted_tps")
    outputs = config["outputs_per_transaction"]
    if type(outputs) is not int or outputs < 1:
        raise ValueError("outputs_per_transaction must be a positive integer")
    # FIPS 203 Table 3: ML-KEM-1024 ciphertext; public input is not configurable.
    kem_bytes = 1568
    raw_bps = tps * outputs * kem_bytes
    cover = positive(config["transport_multiplier"], "transport_multiplier")
    if cover < 1:
        raise ValueError("transport multiplier cannot erase mandatory bytes")
    days = positive(config["offline_days"], "offline_days")
    link_mbps = positive(config["node_receive_mbps"], "node_receive_mbps")
    wallet_gb = positive(config["wallet_catchup_budget_gb"], "wallet_catchup_budget_gb")
    catchup_seconds = positive(config["catchup_deadline_hours"], "catchup_deadline_hours") * 3600
    historical_bytes = raw_bps * 86400 * days
    # Replaying history while keeping up with the live stream needs both rates.
    catchup_bps = historical_bytes * cover / catchup_seconds + raw_bps * cover
    reasons = []
    if raw_bps * cover * 8 / 1e6 > link_mbps:
        reasons.append("continuous_receive_exceeds_link")
    if historical_bytes * cover / 1e9 > wallet_gb:
        reasons.append("historical_download_exceeds_wallet_budget")
    if catchup_bps * 8 / 1e6 > link_mbps:
        reasons.append("history_plus_live_exceeds_catchup_deadline")
    return {"schema_version": 1, "status": "exploratory_lower_bound",
            "decision": "RULED_OUT_BY_LOWER_BOUND" if reasons else "UNRESOLVED",
            "reasons": reasons, "config": config,
            "ml_kem_1024_ciphertext_bytes": kem_bytes,
            "kem_only_bytes_per_transaction": outputs * kem_bytes,
            "kem_only_gb_per_day": raw_bps * 86400 / 1e9,
            "continuous_floor_mbps_with_transport": raw_bps * cover * 8 / 1e6,
            "historical_floor_gb_with_transport": historical_bytes * cover / 1e9,
            "catchup_plus_live_floor_mbps": catchup_bps * 8 / 1e6,
            "excluded": ["proofs, commitments, nullifiers, note payload and headers",
                "verification, scanning, storage, retries and real anonymity protocol",
                "snapshot/index alternatives require their own privacy/security analysis"],
            "interpretation": "A failed floor rules out this declared full-scan envelope. "
                "UNRESOLVED is not a feasibility pass, measured result or gate approval."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("config", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    raw = args.config.read_bytes()
    result = screen(json.loads(raw))
    result["config_sha256"] = hashlib.sha256(raw).hexdigest()
    result["source_sha256"] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    with args.output.open("x", encoding="utf-8") as stream:
        stream.write(json.dumps(result, indent=2, allow_nan=False) + "\n")


if __name__ == "__main__":
    main()
