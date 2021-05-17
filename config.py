"""
Application config with run-time type checking via pydantic
Ref:
  https://rednafi.github.io/digressions/python/2020/06/03/python-configs.html
"""
from typing import Optional, Union

from pydantic import BaseModel, BaseSettings, Field


class AppConfig(BaseModel):
    """Application configurations."""

    var_a: int = 33
    var_b: float = 22.0


class GlobalConfig(BaseSettings):
    """Global configurations."""

    # These variables will be loaded from the .env file. However, if
    # there is a shell environment variable having the same name,
    # that will take precedence.

    APP_CONFIG: AppConfig = AppConfig()

    # define global variables with the Field class
    ENV_STATE: Optional[str] = Field(default=None, env="ENV_STATE")

    # environment specific variables do not need the Field class
    REDIS_HOST: Optional[str] = None
    REDIS_PORT: Optional[int] = None
    REDIS_PASS: Optional[str] = None

    class Config:
        """Loads the dotenv file."""

        env_file: str = ".env"


class DevConfig(GlobalConfig):
    """Development configurations"""

    class Config:
        env_prefix: str = "DEV_"


class ProdConfig(GlobalConfig):
    """Production configurations"""

    class Config:
        env_prefix: str = "PROD_"


def factory_config(env_state: str) -> Union[DevConfig, ProdConfig]:
    """Configuration factory"""
    env_config_map = {"DEV": DevConfig, "PROD": ProdConfig}
    return env_config_map[env_state.upper()]()
