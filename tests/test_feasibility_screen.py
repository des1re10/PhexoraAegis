"""A lower bound may reject an envelope but must never certify feasibility."""

import json
import runpy
from pathlib import Path

import pytest

root = Path(__file__).parents[1]
screen = runpy.run_path(str(root / "tools/feasibility_screen.py"))["screen"]


def config():
    return json.loads((root / "Documentation/ResearchEvaluation/receive_floor_config.json").read_text())


def test_kem_only_floor_rejects_the_declared_low_bandwidth_profile():
    result = screen(config())
    assert result["kem_only_bytes_per_transaction"] == 3136
    assert result["kem_only_gb_per_day"] == pytest.approx(270.9504)
    assert result["decision"] == "RULED_OUT_BY_LOWER_BOUND"
    assert len(result["reasons"]) == 3


def test_generous_budget_remains_unresolved_and_catchup_includes_live_traffic():
    data = config()
    data["node_receive_mbps"] = 1000
    data["wallet_catchup_budget_gb"] = 1000
    result = screen(data)
    assert result["decision"] == "UNRESOLVED"
    assert result["catchup_plus_live_floor_mbps"] == pytest.approx(50.176)


@pytest.mark.parametrize("field,value", [
    ("accepted_tps", float("nan")), ("outputs_per_transaction", True),
    ("transport_multiplier", .5), ("offline_days", 0),
    ("node_receive_mbps", -1), ("wallet_catchup_budget_gb", float("inf"))])
def test_invalid_inputs_fail(field, value):
    data = config()
    data[field] = value
    with pytest.raises(ValueError):
        screen(data)
