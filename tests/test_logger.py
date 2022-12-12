"""
logger tests
"""


from src.python_template.config import get_logger


def test_logger():
    """do some tests"""
    logger = get_logger(logger_name=__name__)
    logger.info("hello")
