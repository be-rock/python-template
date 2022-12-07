import logging
import os

APP_ENV = os.getenv("APP_ENV", "dev")
DEBUG = True if os.getenv("DEBUG", "").lower().startswith("y") else False
LOG_LEVEL = logging.DEBUG if DEBUG else logging.INFO
LOG_FILE = 'app.log'
LOG_FORMAT = "%(asctime)s | %(levelname)s | %(name)s | %(message)s"
LOG_HOME = os.getenv("LOG_DIR", ".")

LOGGING_CONFIG = dict(
    version=1,
    disable_existing_loggers=True,
    formatters={
        'standard': {
            'format': LOG_FORMAT
        },
    },
    handlers={
        'default': {
            'level': LOG_LEVEL,
            'formatter': 'standard',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout',  # Default is stderr
        },
        'file_handler': {
            'level': LOG_LEVEL,
            'formatter': 'standard',
            'class': 'logging.handlers.TimedRotatingFileHandler',
            'filename': LOG_FILE,
            'when': 'm', # minute
            'interval': 1,
        },
    },
    loggers={
        '': {  # root logger
            'handlers': ['default', 'file_handler'],
            'level': LOG_LEVEL, # only log entries this level and above will be included
            'propagate': False
        },
        # '__main__': {  # if __name__ == '__main__'
        #     'handlers': ['default', 'file_handler'],
        #     'level': LOG_LEVEL,
        #     'propagate': False
        # },
    }
)
def get_logger(logger_name: str, logging_config: dict = LOGGING_CONFIG) -> logging.Logger:
    logging.config.dictConfig(logging_config)
    return logging.getLogger(logger_name)

# logger = get_logger(logger_name=__name__)
# logger.info("app_stuff")