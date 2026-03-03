<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# site — Static Web Site

## Purpose
Static web site files for deep linking, universal links, and public-facing pages. Contains Apple App Site Association, Android asset links, and standalone web pages for privacy policy, support, and terms.

## Key Files / Subdirectories

| Path | Description |
|------|-------------|
| `.well-known/apple-app-site-association` | Apple Universal Links config — links iOS deep links to bundle ID |
| `.well-known/assetlinks.json` | Android App Links config — links Android deep links to package |
| `privacy-policy/index.html` | Privacy policy web page |
| `support/index.html` | Support / contact web page |
| `terms/index.html` | Terms of service web page |
| `images/` | Site image assets |

## For AI Agents

### Working In This Directory
- `.well-known/` files are critical for deep linking — do not modify without testing on device
- `apple-app-site-association` must reference correct bundle ID: `com.ginger.mypill`
- `assetlinks.json` must reference correct package name: `com.ginger.mypill`
- Changes to `.well-known/` files require app rebuild + redeployment to take effect
- Deploy via `firebase deploy --only hosting` (if configured) or Cloudflare Pages

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
