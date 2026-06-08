# FitPulse

## Goal
Build FitPulse: an AI-powered fitness tracker with Flutter web frontend + FastAPI backend.

## Constraints & Preferences
- Flutter web only (no Android/iOS).
- Google Sign-In for auth, Firebase Firestore for data, Cloudinary for photo hosting.
- Backend on Railway, frontend on Firebase Hosting, both auto-deploy via CI/CD.
- All services on free tiers — no billing.

## Architecture
- **Frontend**: Flutter web → Firebase Hosting → `https://fitpu1se.web.app`
- **Backend**: FastAPI → Railway → `https://just-transformation-production-99ff.up.railway.app`
- **Auth**: Google Sign-In via Firebase Auth (FirebaseAuth.signInWithPopup)
- **Database**: Firestore (food_logs, photos, users collections)
- **AI**: Google Gemini 3 Flash Preview (food scan via backend)
- **Photos**: Cloudinary (cloud `dywystvlf`, unsigned upload preset `Fitpu1se`)

## What's Done

### Backend
- FastAPI app with `/health`, `POST /api/scan-food` (Gemini), `GET /api/search-food` (USDA proxy)
- Deployed to Railway, connected to GitHub for auto-deploy
- CORS configured for frontend origin

### Frontend
- Flutter project with Riverpod, go_router, Firebase, image_picker, http, intl
- Material 3 teal theme with light/dark mode
- 5-tab layout (Home, Calories, Exercises, Photos, Subscribe)
- Google Sign-In via Firebase Auth popup (OAuth configured with authorized JavaScript origins + redirect URIs)
- Firestore persistence for food logs, streak, photos
- Real data on Home tab (calorie total, streak)
- Photos tab (Cloudinary upload → Firestore)
- Exercises tab (5 workout categories)
- Subscribe tab (premium upsell UI)

### CI/CD
- **Frontend**: GitHub Actions (`deploy.yml`) — flutter build → firebase deploy on push to main touching `fitpulse/**`
- **Backend**: Railway native GitHub integration — auto-deploys on push to main touching `backend/**`

### Git
- Repo: `https://github.com/sohamgudewar/FitPu1se`
- `.gitignore` excludes `.venv`, `__pycache__`, `build/web`, `.env`

## Session Summary (June 9, 2026)
1. Fixed Firestore persistence — FoodLog model, firestore_service.dart with providers
2. Updated Home tab with real calorie total + streak from Firestore
3. Fixed Photos tab to persist to Firestore
4. Deployed frontend to Firebase Hosting
5. Set up GitHub Actions for frontend auto-deploy
6. Set up backend deploy to Railway via GitHub Actions (failed with CLI) → switched to Railway native GitHub integration ✅
7. Fixed Google Sign-In on Flutter Web — added meta tag, switched to FirebaseAuth.signInWithPopup, configured OAuth JavaScript origins + redirect URIs ✅

## Key URLs
| Service | URL |
|---------|-----|
| Frontend | https://fitpu1se.web.app |
| Backend API | https://just-transformation-production-99ff.up.railway.app |
| GitHub | https://github.com/sohamgudewar/FitPu1se |
| Firebase Console | https://console.firebase.google.com/project/fitpu1se |
| Railway Dashboard | https://railway.app/dashboard |
| Google Cloud Credentials | https://console.cloud.google.com/apis/credentials |

## Key Secrets (set in GitHub)
- `FIREBASE_TOKEN` ✅
- `RAILWAY_TOKEN` ✅

## Next Steps / Ideas
- Workout logging (log sets/reps/weight per exercise)
- Water tracker (daily intake counter)
- Dashboard / charts (calorie trends, macros)
- Weight tracking (log weight, trend chart)
- Meal plans (generate via Gemini)
- Meal plan generator via Gemini
- Nutrition insights / dashboard
- Custom domain ($10-15/yr)
