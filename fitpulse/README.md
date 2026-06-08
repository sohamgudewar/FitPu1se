# FitPulse

AI-powered fitness tracker with Flutter web frontend + FastAPI backend.

**Live:** https://fitpu1se.web.app

## Tech Stack

| Layer       | Tech                                      |
|-------------|-------------------------------------------|
| Frontend    | Flutter 3.44 (web-only), Riverpod, go_router |
| Backend     | FastAPI, Gemini Vision, USDA Food Data Central |
| Auth        | Firebase Auth + Google Sign-In            |
| Database    | Cloud Firestore                           |
| Images      | Cloudinary (unsigned upload preset)       |
| Hosting     | Firebase Hosting (frontend), Railway (backend) |

## Features

- **Home** — daily calorie total, streak tracking
- **Calories** — scan food photos via Gemini AI or search USDA database
- **Exercises** — categorized workouts (Push, Pull, Legs, Core, Cardio)
- **Photos** — upload progress photos to Cloudinary, persisted in Firestore
- **Subscribe** — premium upsell UI

## Local Development

### Prerequisites
- Flutter 3.44+ (`C:\flutter`)
- Python 3.12+ with venv

### Backend
```bash
cd backend
.venv\Scripts\activate
uvicorn main:app --reload --port 8000
```

### Frontend
```bash
cd fitpulse
flutter pub get
flutter run -d chrome
```

### Deploy Frontend
```bash
cd fitpulse
firebase deploy --only hosting
```

## Upcoming

- [ ] GitHub Actions auto-deploy
- [ ] Meal plans / weekly calendar
- [ ] Workout logging
- [ ] Weight tracking with charts
- [ ] Nutrition insights
- [ ] Water intake tracker
- [ ] Custom domain

## API Endpoints

| Method | Path                | Description                 |
|--------|---------------------|-----------------------------|
| GET    | `/health`           | Health check                |
| POST   | `/api/scan-food`    | Analyze food photo (Gemini) |
| GET    | `/api/search-food`  | Search USDA food database   |
