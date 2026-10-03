"""Unit checks for the cloud OCR publication quality gate."""
from __future__ import annotations

import sys
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from backend.tools.sync_cloud import QualityError, process_document, validate  # noqa: E402


def rows(count: int, *, marathi: bool = True, serials: bool = True) -> list[dict]:
    return [
        {
            "name": f"मतदार नाव {i}" if marathi else f"Voter Name {i}",
            "name_normalized": f"मतदार नाव {i}" if marathi else f"voter name {i}",
            "relation_name": f"नातेवाईक {i}",
            "relation_name_normalized": f"नातेवाईक {i}",
            "serial": str(i + 1) if serials else "",
            "epic": f"ZCG{i:07d}",
            "page": i // 20 + 1,
        }
        for i in range(count)
    ]


good = validate(rows(100), pages=5, ocr_pages=5)
assert good["status"] == "passed"
assert good["records"] == 100
assert good["mixed_script_records"] == 0
assert good["duplicate_serials"] == 0

mixed = rows(100)
mixed[24]["name"] = "राजकुमार AGA गुंड"
mixed_report = validate(mixed, pages=5, ocr_pages=5)
assert mixed_report["status"] == "passed"
assert mixed_report["mixed_script_records"] == 1
assert mixed_report["mixed_script_examples"][0]["serial"] == "25"
assert any("retained and searchable" in warning for warning in mixed_report["warnings"])

repeated_serial = rows(100)
repeated_serial[24]["serial"] = "24"
repeated_serial_report = validate(repeated_serial, pages=5, ocr_pages=5)
assert repeated_serial_report["status"] == "passed"
assert repeated_serial_report["duplicate_serials"] == 1
assert any("isolated" in warning for warning in repeated_serial_report["warnings"])

wrong_unique_serial = rows(100)
wrong_unique_serial[24]["serial"] = "125"
wrong_unique_report = validate(wrong_unique_serial, pages=5, ocr_pages=5)
assert wrong_unique_report["status"] == "passed"
assert wrong_unique_report["serial_sequence_missing"] >= 1
assert wrong_unique_report["serial_order_anomalies"]

many_serial_errors = rows(100)
for index in range(10, 16):
    many_serial_errors[index]["serial"] = ""
try:
    validate(many_serial_errors, pages=5, ocr_pages=5)
except QualityError as error:
    assert error.report["blank_serials"] == 6
else:
    raise AssertionError("Quality gate accepted a repeated serial extraction failure")

large_roll_with_isolated_serial_damage = rows(1115)
for index in (305, 405, 505, 605, 705, 805, 905, 1005):
    large_roll_with_isolated_serial_damage[index]["serial"] = str(index)
large_roll_report = validate(
    large_roll_with_isolated_serial_damage,
    pages=56,
    ocr_pages=56,
)
assert large_roll_report["status"] == "passed"
assert large_roll_report["duplicate_serials"] == 8
assert large_roll_report["isolated_error_allowance"] == 12
assert any("isolated" in warning for warning in large_roll_report["warnings"])

repeated_identity = rows(100)
repeated_identity[24]["name"] = repeated_identity[23]["name"]
repeated_identity[24]["name_normalized"] = repeated_identity[23]["name_normalized"]
repeated_identity[24]["epic"] = repeated_identity[23]["epic"]
identity_report = validate(repeated_identity, pages=5, ocr_pages=5)
assert identity_report["status"] == "passed"
assert identity_report["duplicate_names"] == 1
assert identity_report["duplicate_epics"] == 1
assert len(identity_report["warnings"]) >= 2


class UnclaimableDocument:
    def rpc(self, name, data):
        assert name == "claim_document_for_indexing"
        return False


with redirect_stdout(StringIO()):
    skipped_code = process_document(UnclaimableDocument(), "test-document", workers=1,
                                    claim=True, final_attempt=False)
assert skipped_code == 3

for bad_rows, pages, reason in [
    (rows(5), 20, "too few records"),
    (rows(100, serials=False), 5, "missing serials"),
]:
    try:
        validate(bad_rows, pages=pages, ocr_pages=pages)
    except QualityError:
        pass
    else:
        raise AssertionError(f"Quality gate accepted {reason}")

latin_report = validate(rows(100, marathi=False), pages=5, ocr_pages=5)
assert latin_report["status"] == "passed"
assert any("not Devanagari" in warning for warning in latin_report["warnings"])

missing_epics = rows(100)
missing_epics[10]["epic"] = ""
missing_epics[11]["epic"] = ""
epic_report = validate(missing_epics, pages=5, ocr_pages=5)
assert epic_report["status"] == "passed"
assert epic_report["blank_epics"] == 2
assert epic_report["epic_coverage"] == 0.98

print("PASS: cloud OCR quality gate")
