import json

import httpx
from fastapi import APIRouter, File, HTTPException, Query, UploadFile
from google import genai
from google.genai import types

from app.config import settings
from app.schemas.food import FoodScanResult, FoodSearchItem, FoodSearchResponse

router = APIRouter(prefix="/api", tags=["food"])

SCAN_PROMPT = """Analyze this food photo and return nutrition data in JSON format:
{
  "food_name": "name of the food",
  "calories": number,
  "protein_g": number,
  "carbs_g": number,
  "fat_g": number,
  "serving_size": number,
  "serving_unit": "g or ml or piece"
}
Use reasonable estimates based on visual appearance. Return ONLY valid JSON."""


@router.post("/scan-food")
async def scan_food(file: UploadFile = File(...)) -> FoodScanResult:
    if not settings.gemini_api_key:
        raise HTTPException(status_code=503, detail="Gemini API key not configured")

    image_bytes = await file.read()

    client = genai.Client(api_key=settings.gemini_api_key)
    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=[types.Part.from_bytes(data=image_bytes, mime_type=file.content_type or "image/jpeg"), SCAN_PROMPT],
    )

    raw = response.text.strip()
    if raw.startswith("```"):
        raw = raw.strip("`").removeprefix("json").strip()

    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        raise HTTPException(status_code=422, detail=f"Failed to parse Gemini response: {raw[:200]}")

    return FoodScanResult(
        food_name=data.get("food_name", "Unknown"),
        calories=float(data.get("calories", 0)),
        protein_g=float(data.get("protein_g", 0)),
        carbs_g=float(data.get("carbs_g", 0)),
        fat_g=float(data.get("fat_g", 0)),
        serving_size=float(data.get("serving_size", 100)),
        serving_unit=data.get("serving_unit", "g"),
    )


@router.get("/search-food")
async def search_food(
    query: str = Query(min_length=1),
    page_size: int = Query(default=10, le=50),
) -> FoodSearchResponse:
    if not settings.usda_api_key:
        raise HTTPException(status_code=503, detail="USDA API key not configured")

    usda_url = "https://api.nal.usda.gov/fdc/v1/foods/search"
    params = {"api_key": settings.usda_api_key, "query": query, "pageSize": page_size, "dataType": "Foundation,SR Legacy,Branded"}

    async with httpx.AsyncClient() as client:
        resp = await client.get(usda_url, params=params)

    if resp.status_code != 200:
        raise HTTPException(status_code=502, detail=f"USDA API error: {resp.status_code}")

    data = resp.json()
    results = []
    for item in data.get("foods", []):
        calories = None
        for nutrient in item.get("foodNutrients", []):
            if nutrient.get("nutrientId") == 1008:
                calories = nutrient.get("value")
                break

        results.append(
            FoodSearchItem(
                fdc_id=item.get("fdcId", 0),
                food_name=item.get("description", "Unknown"),
                brand_name=item.get("brandName"),
                calories_per_100g=calories,
            )
        )

    return FoodSearchResponse(results=results, total=data.get("totalHits", len(results)))
