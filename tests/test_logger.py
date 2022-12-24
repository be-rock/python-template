"""
logger tests
"""

from src.python_template.config import get_logger

logger = get_logger(logger_name=__name__)


def test_logger():
    """do some tests"""
    logger.info("hello")
