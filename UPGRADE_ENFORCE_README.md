# Mandatory App Update (Play Store only)

The app uses the **upgrader** package so that when a newer version is on the Play Store, users **must update** before they can use the app. They cannot dismiss the dialog or go back until they update.

**No backend** – Version check depends only on the app and the upgrader package (Play Store).

## Internal testing

The upgrader reads version info from the **public Play Store page** for your app. When the app is only in **internal testing**, that page is often not available (Google returns 404 or a restricted page), so the version check fails and the update dialog **will not show** in internal testing.

The mandatory-update dialog **will work** when:
- The app is on a **public track** (production, or sometimes open testing), so the Play Store listing is reachable, or
- You add the Play Store description tag below so that when the listing is reachable, old versions get the minimum version and are forced to update.

## "Can't find an app in the Play Store" in logs

If you see:
```text
upgrader: Can't find an app in the Play Store with the id: com.astrobharatai.astrouser
```
then the store lookup is failing. Common causes:

1. **Internal testing** – The app is only in internal testing; the public store page is not available. Promote to production (or open testing) for the upgrader to work.
2. **Country** – The app uses `countryCode: 'in'` so the Play Store is queried in India. If your app is only in India, keep this. If it’s in other countries too, you can remove `countryCode` in `main.dart` so the device’s country is used.
3. **Not published** – The app must be published to at least one track (not just a draft).
4. **Package name** – The Play Store app must have application ID `com.astrobharatai.astrouser`.

## What was changed

1. **`lib/utils/app_constant.dart`**  
   - `AppConstant.minAppVersion` – minimum version required. Update this when you release a new version (e.g. `'1.0.1'`).

2. **`lib/main.dart`**  
   - Upgrader is configured with:
     - `minAppVersion` from `AppConstant`
     - `durationUntilAlertAgain: Duration.zero` so the dialog is not delayed
     - `countryCode: 'in'` for India store lookup
     - `shouldPopScope` so the user cannot close or go back when an update is available or they are below the minimum version

## Required: Play Store description tag

For **old installs** (e.g. 1.0.0) to be forced to update when you release 1.0.1, the upgrader can read the minimum version from the **Play Store listing**.

Add this exact text to your app’s **Full description** or **Short description** on Google Play Console:

```text
[Minimum supported app version: 1.0.1]
```

- Replace `1.0.1` with the **current store version** you want to enforce.
- When you release a new version (e.g. 1.0.2), update the tag to `[Minimum supported app version: 1.0.2]` in the Play Store description.

If this tag is missing, only the in-app `AppConstant.minAppVersion` is used (which is shipped with the **new** build), so users on older builds may not see the force-update screen until you add the tag.

## Why the update dialog does not show when only version code changes

The upgrader package compares **version name** (e.g. `1.0.1`) only. It does **not** compare version code (the `+48` part). So if you upload build `1.0.1+49` and the previous was `1.0.1+48`, the store still shows version name `1.0.1` and the app will not see an update. You must **increment the version name** on each release (e.g. `1.0.1+48` → `1.0.2+49`).

## Checklist for each new release

1. Bump version in `pubspec.yaml`: **increase both** version name and build number (e.g. `1.0.1+48` → `1.0.2+49`). The version name must increase for the update prompt to appear.
2. Set `AppConstant.minAppVersion` in `lib/utils/app_constant.dart` to the new version string when you want to force update (e.g. `'1.0.2'`). Leave at `'1.0.0'` if you don’t want to force.
3. In Play Store Console, add or update the description line:  
   `[Minimum supported app version: 1.0.2]`  
   (use the same version as in step 2).
4. Build and upload the new build to the Play Store.

After this, once the app is on a track where the store listing is public, users on older versions will see the update dialog and will not be able to proceed without updating.
