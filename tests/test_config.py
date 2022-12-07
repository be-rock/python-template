"""
App Config tester
"""
from config import CONFIG

def test_config():
    assert CONFIG.servers.alpha.ip == "10.0.0.1"