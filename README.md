# FitPulse

FitPulse is a Flutter Web fitness-tracking prototype with a small FastAPI service.

## Checked-in functionality

- Firebase Authentication integration for Google sign-in
- Firestore-backed food logs and progress photos
- Calorie and macro summaries, meal grouping, workout screens, and responsive navigation
- Cloudinary photo-upload integration
- A FastAPI health route, Gemini-based food-image analysis route, and USDA food-search proxy
- Local caching for selected search and exercise data

## Repository layout

- `fitpulse/` — Flutter Web client
- `backend/` — FastAPI service
- `.github/workflows/` — checked-in automation configuration, where present

## Limitations and verification status

- This is a prototype, not medical or nutritional advice. AI-generated food estimates can be wrong and should be reviewed by the user.
- The repository contains one default Flutter widget test and no backend test suite; it does not establish nutrition accuracy, security, availability, or production readiness.
- Firebase, Cloudinary, Gemini, USDA, Railway, and hosting behavior depend on external configuration and service availability.
- Deployment URLs mentioned in internal project notes are historical operational claims. Verify them directly before presenting them as currently live.
- The Subscribe screen is an interface prototype; the repository does not contain a completed billing integration.

See `fitpulse/README.md` for Flutter-generated development commands and inspect `backend/app/routers/` for the current API behavior.
