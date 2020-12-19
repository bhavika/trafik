from unittest import TestCase
import pytest
from click.testing import CliRunner
import click
from traffik.scripts import cli, validate_cityname


class TestConsole(TestCase):
    def test_basic(self):
        runner = CliRunner()
        result = runner.invoke(cli, ["process", "--city", "berlin"])
        print(result)
        assert result.exit_code == 0

    def test_validate_cityname(self):
        with pytest.raises(click.BadParameter):
            validate_cityname(None, None, "dc")
