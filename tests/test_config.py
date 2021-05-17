"""
App Config tester
"""
import os

from config import factory_config

cnf = factory_config(env_state=os.getenv("ENV_STATE", "DEV"))


def test_config():
    APP_CONFIG = cnf.APP_CONFIG
    assert APP_CONFIG.var_a == 33
    assert cnf.REDIS_HOST == "127.0.0.1"
