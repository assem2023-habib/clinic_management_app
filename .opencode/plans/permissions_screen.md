# Permissions Screen Implementation Plan

## Files to Create (6 new)
1. `lib/presentation/screens/permissions/permissions_painters.dart` - PsPulseRing, PsParticleData, PsParticlePainter, PsSeededRandom
2. `lib/presentation/screens/permissions/widgets/ps_hero_icon.dart` - Shield icon + rotating ring + float + medical cross badge
3. `lib/presentation/screens/permissions/widgets/ps_permission_item.dart` - Camera/Location row with cancel icon
4. `lib/presentation/screens/permissions/widgets/ps_footer.dart` - Settings glass button (snackbar) + Try Later (→ dashboard)
5. `lib/presentation/screens/permissions/permissions_screen.dart` - Main screen (StatefulWidget + TickerProvider, ≤200 lines)

## Files to Modify (3)
6. `lib/core/constants/app_strings.dart` - Add 10 `ps_*` strings after pw strings
7. `lib/core/constants/app_routes.dart` - Add `static const permissions = '/permissions';`
8. `lib/main.dart` - Import + route case for PermissionsScreen
