from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    cors_origins: str = "http://localhost:5000,http://localhost:3000,https://fitpulse.web.app"
    gemini_api_key: str = ""
    usda_api_key: str = ""

    @property
    def cors_origins_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
