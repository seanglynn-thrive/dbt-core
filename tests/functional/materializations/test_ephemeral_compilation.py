import pytest
from dbt.tests.util import run_dbt

# Note: This tests compilation only, so is a dbt Core test and not an adapter test.
# There is some complicated logic in core/dbt/compilation.py having to do with
# ephemeral nodes and handling multiple threads at the same time. This test
# fails fairly regularly if that is broken, but does occasionally work (depending
# on the order in which things are compiled). It requires multi-threading to fail.

from tests.functional.materializations.fixtures import (
    fct_eph_first_sql,
    int_eph_first_sql,
    schema_yml,
    bar_sql,
    bar1_sql,
    bar2_sql,
    bar3_sql,
    bar4_sql,
    bar5_sql,
    baz_sql,
    baz1_sql,
    foo_sql,
    foo1_sql,
    foo2_sql,
)


class TestEphemeralCompilation:
    @pytest.fixture(scope="class")
    def models(self):
        return {
            "int_eph_first.sql": int_eph_first_sql,
            "fct_eph_first.sql": fct_eph_first_sql,
            "schema.yml": schema_yml,
        }

    def test_ephemeral_compilation(self, project):
        # Note: There are no models that run successfully. This testcase tests running tests.
        results = run_dbt(["run"])
        assert len(results) == 0

        results = run_dbt(["test"])
        len(results) == 4


# From: https://github.com/jeremyyeo/ephemeral-invalid-sql-repro/tree/main/models
class TestLargeEphemeralCompilation:
    @pytest.fixture(scope="class")
    def models(self):

        return {
            "bar.sql": bar_sql,
            "bar_1.sql": bar1_sql,
            "bar_2.sql": bar2_sql,
            "bar_3.sql": bar3_sql,
            "bar_4.sql": bar4_sql,
            "bar_5.sql": bar5_sql,
            "baz.sql": baz_sql,
            "baz_1.sql": baz1_sql,
            "foo.sql": foo_sql,
            "foo_1.sql": foo1_sql,
            "foo_2.sql": foo2_sql,
        }

    def test_ephemeral_compilation(self, project):
        # 8/11 table models are built as expected. no compilation errors
        results = run_dbt(["compile"])
        assert len(results) == 8
