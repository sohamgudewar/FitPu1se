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

## V2 Session Plan
| # | Area | What |
|---|------|------|
| 1 | Design | Purple `#6C63FF` accent, DM Sans + Syne fonts, dark mode toggle, refined ThemeData |
| 2 | Home | Animated calorie ring (CustomPainter), macro bars (carbs/protein/fat) |
| 3 | Exercises | Rest timer between sets, workout completion summary dialog |
| 4 | Calories | Editable food quantities, per-meal grouping |
| 5 | Photos | Side-by-side comparison, pose overlay guide with photo_view |
| 6 | Offline | Hive cache for food search + exercise list with TTL |
| 7 | Layout | Responsive desktop (side nav) vs mobile (bottom nav) |

## Session Summary (June 10, 2026)
1. **V2 Session 1: Design System** — `google_fonts`, `shimmer`, `lottie` added; purple `#6C63FF` seed; DM Sans body + Syne display fonts; `ThemeOption` provider (system/light/dark toggle); refined Card, Input, FilledButton, NavBar, SnackBar styles ✅
2. **V2 Session 2: Home** — Animated calorie ring (`CustomPainter` with `AnimationController` + `CurvedAnimation`); macro bars (Carbs/Protein/Fat with `LinearProgressIndicator`); macro providers in firestore_service ✅
3. **V2 Session 3: Exercises** — Checkbox per exercise, rest timer dialog (circular countdown, pause/skip), workout completion summary dialog with stats ✅
4. **V2 Session 4: Calories** — Editable serving qty in scan result card + search dialog; macros recalculate in real time; `mealType` field on FoodLog; today's entries grouped by Breakfast/Lunch/Dinner/Snack ✅
5. **V2 Session 5: Photos** — `photo_view` package; side-by-side comparison screen (long-press two photos, compare); pose overlay toggle (crosshair + body guide via CustomPainter) ✅

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
