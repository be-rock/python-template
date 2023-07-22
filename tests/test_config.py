"""
App Config tester
"""
from src.python_template.config import CONFIG, LOGGING_CONFIG


def test_config():
    """test the config"""
    assert CONFIG.servers.alpha.ip == "10.0.0.1"


def test_logging_config():
    """test the config"""
    assert LOGGING_CONFIG.get("formatters")
