import logging
import os
from logging.handlers import TimedRotatingFileHandler

from pythonjsonlogger import jsonlogger

LOG_FORMATTER = "'%(asctime)s - %(name)s - %(levelname)s - %(message)s'"


def get_stream_log_handler(
    formatter: logging.Formatter = jsonlogger.JsonFormatter(LOG_FORMATTER),
):
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    return handler


def get_timed_rotating_log_handler(
    log_dir: str = "/tmp",
    log_file: str = "app.log",
    log_rotate_time: str = "midnight",
    backup_count: int = 0,
    formatter: logging.Formatter = jsonlogger.JsonFormatter(LOG_FORMATTER),
):
    handler = TimedRotatingFileHandler(
        os.path.join(log_dir, log_file),
        when=log_rotate_time,
        backupCount=backup_count,
    )
    handler.setFormatter(formatter)
    return handler


def get_logger(
    handler: logging.Handler,
    logger_name: str,
    level: int = logging.INFO,
):
    logger = logging.getLogger(logger_name)
    logger.setLevel(level=level)
    logger.addHandler(hdlr=handler)
    logger.propagate = False
    return logger


def test_logger():
    file_logger = get_logger(
        handler=get_timed_rotating_log_handler(), logger_name=__name__
    )
    file_logger.info("classic message", extra={"special": "value", "run": 12})
    stream_logger = get_logger(
        handler=get_stream_log_handler(), logger_name=__name__
    )
    stream_logger.info("classic message", extra={"special": "value", "run": 12})
