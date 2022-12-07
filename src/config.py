from dataclasses import dataclass
import datetime
from logging import Formatter
import os
from pathlib import Path
from typing import Union

import tomli as toml
from pydantic import BaseModel, BaseSettings

APP_ENV = os.environ.get("APP_ENV", "dev") # dev, tst, prd
DEBUG = True if os.environ.get("DEBUG", "").lower().startswith("y") else False

#
# this sample pydantic model is based on a sample TOML file provided in the
# official TOML docs https://toml.io/
#
# class Owner(BaseModel):
#     name: str
#     dob: datetime.datetime

# class Database(BaseModel):
#     enabled: bool
#     ports: list[int]
#     data: list[Union[list[str], list[int]]]
#     temp_targets: dict[str, float]

# class ServerDetail(BaseModel):
#     ip: str
#     role: str

# class Servers(BaseModel):
#     alpha: ServerDetail
#     beta: ServerDetail

# class Config(BaseSettings):
#     title: str
#     owner: Owner
#     database: Database
#     servers: Servers
#     class Config:
#         allow_mutation = False

# @dataclass
# class LoggingFormat:
#     format: str

# @dataclass
# class LoggingConf:
#     disable_existing_loggers: bool
#     formatters: dict[str, LoggingFormat]
#     version: int

# @dataclass(frozen=True)
# class Config:
#     logging: LoggingConf

def read_app_config_file(config_file: str = "app-conf.toml") -> dict:
    path = Path(config_file)
    if not path.is_absolute():
        path = (Path(__file__).parent.absolute() / config_file)
    with open(path.as_posix(), "rb") as conf:
        return toml.load(conf)


# def set_app_env_vars(env_file: str = ".env") -> None:
#     with open(env_file, 'r') as f:
#         data = f.read()
#         for item in data.rstrip('\n').split('\n'):
#             k, v = item.split('=')
#             os.environ[k] = v

_conf = read_app_config_file()
from pprint import pprint
from dataclasses import asdict
CONFIG = Config(**_conf)
pprint(_conf)
pprint(CONFIG)
assert _conf == asdict(CONFIG)
print(CONFIG.logging)
# set_app_env_vars(env_file='/tmp/.env')
