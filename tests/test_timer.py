"""
test for a basic timer decorator
"""
import json
from functools import wraps
from time import perf_counter

from tests.test_logger import get_logger, get_timed_rotating_log_handler

handler = get_timed_rotating_log_handler()
logger = get_logger(handler)


def timer_logger(logger):
    """a log decorator that captures before/after timestamps as well
    as an elapsed time
    """

    def decorator_time_logger(func):
        @wraps(func)
        def wrapper_time_logger(*args, **kwargs):
            start = perf_counter()
            logger.info(f"begin {func.__name__}")
            result = func(*args, **kwargs)
            logger.info(
                f"end {func.__name__}",
                extra={"elapsed": round((perf_counter() - start).real, 3)},
            )
            return result

        return wrapper_time_logger

    return decorator_time_logger


def test_timer_logger_decorator():
    @timer_logger(logger=logger)
    def func():
        assert True

    func()
    contains_elapsed = []
    with open("/tmp/app.log", "r") as f:
        for line in f:
            data = json.loads(line)
            contains_elapsed.append("elapsed" in data.keys())
    assert any(contains_elapsed)
