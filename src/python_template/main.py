from src.python_template.config import get_logger

logger = get_logger(logger_name=__name__)


def main() -> None:
    logger.info("hello from main")


if __name__ == "__main__":
    main()
