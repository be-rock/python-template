import datetime
import logging
import os
import time
from pathlib import Path
from typing import Union

import tomllib as toml
from pydantic import BaseModel, BaseSettings

APP_ENV = os.environ.get("APP_ENV", "dev")  # dev, tst, prd
DEBUG = bool(os.environ.get("DEBUG", "").lower().startswith("y"))
LOG_LEVEL = logging.DEBUG if DEBUG else logging.INFO
LOG_FILE = "app.log"
LOG_FORMAT = "%(asctime)s | %(levelname)s | %(name)s | %(message)s"
LOG_HOME = os.getenv("LOG_DIR", ".")

# https://docs.python.org/3/howto/logging-cookbook.html#formatting-times-using-utc-gmt-via-configuration
class UTCFormatter(logging.Formatter):
    converter = time.gmtime


# LOGGING_CONFIG = dict(
#     version=1,
#     disable_existing_loggers=True,
#     formatters={
#         'standard': {
#             'format': LOG_FORMAT,
#             '()': UTCFormatter
#         },
#         'jsonformat': {
#             'format': f'pythonjsonlogger.jsonlogger.JsonFormatter({LOG_FORMAT})'
#         }
#     },
#     handlers={
#         'default': {
#             'level': LOG_LEVEL,
#             'formatter': 'standard',
#             'class': 'logging.StreamHandler',
#             'stream': 'ext://sys.stdout',  # Default is stderr
#         },
#         'json': {
#             'level': LOG_LEVEL,
#             'formatter': 'jsonformat',
#             'class': 'logging.StreamHandler',
#             'stream': 'ext://sys.stdout',  # Default is stderr
#         },
#         'file_handler': {
#             'level': LOG_LEVEL,
#             'formatter': 'standard',
#             'class': 'logging.handlers.TimedRotatingFileHandler',
#             'filename': LOG_FILE,
#             'when': 'm', # minute
#             'interval': 1,
#         },
#     },
#     loggers={
#         '': {  # root logger
#             'handlers': ['default'],
#             'level': LOG_LEVEL, # only log entries this level and above will be included
#             'propagate': False
#         },
#         '__main__': {  # special logger for __main__ or another module
#             'handlers': ['default', 'file_handler'],
#             'level': LOG_LEVEL,
#             'propagate': False
#         },
#         'jsonlogger': {
#             'handlers': ['json'],
#             'level': LOG_LEVEL,
#             'propagate': False
#         },
#     }
# )


def read_toml_config_file(config_file: str) -> dict:
    path = Path(config_file)
    if not path.is_absolute():
        path = Path(__file__).parent.absolute() / config_file
    with open(path.as_posix(), "rb") as conf:
        return toml.load(conf)


def get_logger(
    logger_name: str,
    logging_config: dict = read_toml_config_file(
        config_file="logging-conf.toml"
    ),
) -> logging.Logger:
    logging.config.dictConfig(logging_config)
    return logging.getLogger(logger_name)


#
# this sample pydantic model is based on a sample TOML file provided in the
# official TOML docs https://toml.io/
#
class Owner(BaseModel):
    name: str
    dob: datetime.datetime


class Database(BaseModel):
    enabled: bool
    ports: list[int]
    data: list[Union[list[str], list[int]]]
    temp_targets: dict[str, float]


class ServerDetail(BaseModel):
    ip: str
    role: str


class Servers(BaseModel):
    alpha: ServerDetail
    beta: ServerDetail


class Config(BaseSettings):
    title: str
    owner: Owner
    database: Database
    servers: Servers

    class Config:
        allow_mutation = False


def set_app_env_vars(env_file: str = ".env") -> None:
    with open(env_file, "r") as f:
        data = f.read()
        for item in data.rstrip("\n").split("\n"):
            k, v = item.split("=")
            os.environ[k] = v


log_conf = read_toml_config_file(config_file="logging-conf.toml")
logger = get_logger(logger_name=__name__, logging_config=log_conf)
app_conf = read_toml_config_file(config_file="app-conf.toml")
CONFIG = Config(**app_conf)
set_app_env_vars(env_file=".env")
