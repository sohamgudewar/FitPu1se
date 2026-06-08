from pydantic import BaseModel


class FoodScanResult(BaseModel):
    food_name: str
    calories: float
    protein_g: float
    carbs_g: float
    fat_g: float
    serving_size: float
    serving_unit: str


class FoodSearchItem(BaseModel):
    fdc_id: int
    food_name: str
    brand_name: str | None = None
    calories_per_100g: float | None = None


class FoodSearchResponse(BaseModel):
    results: list[FoodSearchItem]
    total: int
