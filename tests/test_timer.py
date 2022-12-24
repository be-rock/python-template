"""
test for a basic timer decorator
"""
from functools import wraps
from time import perf_counter

from src.python_template.config import get_logger

logger = get_logger(logger_name=__name__)


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
                f"end {func.__name__}, elapsed: "
                f"{round((perf_counter() - start).real, 6)}"
            )
            return result

        return wrapper_time_logger

    return decorator_time_logger


def test_timer_logger_decorator():
    """test the decorator"""

    @timer_logger(logger=logger)
    def func():
        assert True

    func()

    contains_elapsed = []
    with open("/tmp/app.log", "r") as f:
        for line in f:
            contains_elapsed.append("elapsed" in line)
    assert any(contains_elapsed)
