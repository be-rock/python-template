"""
App Config tester
"""
from src.app.config import CONFIG

def test_config():
    assert CONFIG.servers.alpha.ip == "10.0.0.1"
