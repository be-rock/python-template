"""
App Config tester
"""
# from src.python_template.config import CONFIG
from src.python_template.config import CONFIG


def test_config():
    """test the config"""
    assert CONFIG.servers.alpha.ip == "10.0.0.1"
