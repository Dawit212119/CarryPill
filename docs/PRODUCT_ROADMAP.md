# CarryPill — Product transformation roadmap

Goal: move from FYP/MVP to a **production-grade patient medication logistics app** competitive with hospital pharmacy portals and last-mile health delivery apps.

## Current strengths (keep)

- Supabase auth + realtime orders + rider matching
- Multi-step booking (facility, clinics, calendar, payment UI, live status)
- Rider contact (call) and status Lottie animations
- Layered architecture (providers → repos → Supabase)

## Phase 1 — Foundation ✅

| Item | Status |
|------|--------|
| Material 3 theme (`lib/theme/app_theme.dart`) | Done |
| Home + bottom nav redesign (no missing PNG assets) | Done |
| Profile completion gate before ordering | Done |
| Forgot password flow | Done |
| Loading fallback when Rive asset missing | Done |
| Remove dead dependencies | Done |
| Product roadmap (this doc) | Done |

## Phase 2 — Trust & polish (in progress)

- [x] `--dart-define` Supabase keys (`SupabaseConfig` + README)
- [x] Splash + onboarding (`Bootstrap`, `OnboardingPage`)
- [x] Order detail screen + cancel request (`OrderDetailPage`, `orderCancelled`)
- [x] Pull-to-refresh on order history (`OrderHistoryList`)
- [x] In-app notification center (`NotificationsPage`)
- [ ] Wire `AppLocalizations` (EN / MS / ZH)
- [x] Unit + widget tests (`order_status_utils_test`, `EmptyState` test)

## Phase 3 — Domain leadership (in progress)

- [x] **Queue token** number + photo upload (`order-tokens` bucket)
- [x] **Medication checklist** UI per clinic department
- [x] **Live map** for patient (OpenStreetMap + rider stream)
- [x] **Facility search** with distance sort
- [x] **Order timeline** on order detail screen
- [ ] Push notifications (FCM + Supabase Edge Function webhooks)
- [ ] Real payments (Stripe / FPX sandbox for demo)
- [ ] ETA estimate (distance-based)

## Phase 4 — Production hardening

- [ ] RLS: rider public view (id, name, location only — not phone)
- [ ] Storage policies in `schema.sql`
- [ ] Flavors: dev / staging / prod
- [ ] Error reporting (Sentry)
- [ ] Privacy policy + consent screens
- [ ] Accessibility audit (semantics, contrast, screen reader)

## Phase 5 — Ecosystem

- [ ] CarryPillRider parity (shared schema version)
- [ ] Admin/facility web dashboard (optional Supabase + React)
- [ ] Analytics (order funnel, completion rate)

## Success metrics

- Profile completion rate > 80% before first order
- Order placement < 3 minutes median
- Zero crashes on missing assets
- App Store / Play Store ready metadata and screenshots
