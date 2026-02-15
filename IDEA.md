# SwipeClear - Document Swipe Cleaner

> Tinder-style swipe to clean your Downloads folder

## Problem

Downloads folder is a graveyard of forgotten PDFs, APKs, and random files. Existing file managers make cleanup tedious (tap, select, delete, repeat).

## Solution

Swipe left = trash, swipe right = keep. See preview thumbnails. Pay once to delete.

---

## Market Validation

- **Direct Reddit request:** "Is there a Tinder-style swipe app for cleaning up document files?"
- **Photo swipers exist:** PhotoSwooper proves the UX pattern works
- **No document swiper competition found**
- **Target audience:** Everyone with a phone

---

## User Flow

```
1. App opens → "Pick a folder to clean" (default: Downloads)
2. User grants SAF permission to folder
3. Swipe interface:
   - Card shows: thumbnail/icon + filename + size + date
   - Swipe LEFT = mark for deletion
   - Swipe RIGHT = keep
   - Running counter: "🗑️ 23 files · 847 MB"
4. End screen:
   - Grid of thumbnails marked for deletion
   - "47 files · 2.3GB ready to delete"
5. Paywall:
   - "Unlock SwipeClear — $3.99"
   - [Unlock] [Cancel]
6. On payment:
   - Delete files from original locations
   - Satisfying animation (confetti/shredder/black hole)
   - "You freed 2.3GB! 🎉"
```

---

## Technical Stack

| Component | Solution |
|-----------|----------|
| Framework | Flutter |
| File access | Storage Access Framework (SAF) |
| Previews | `thumbnailer` package |
| PDF thumbnails | `pdfrx` or `pdf_render` package |
| IAP | `in_app_purchase` package |
| Backend | None needed |

### Key Technical Notes

- **SAF:** User picks folder once, app gets persistent read/write/delete access. No special permissions needed. Play Store friendly.
- **Previews:** `thumbnailer` handles images (actual thumbnail), PDFs (first page), Excel (first sheet), and icons for everything else.
- **No staging folder:** Files stay in place during swiping. Only track `toDelete` list in memory. Prevents workaround where user deletes staging folder via file manager.

---

## Monetization

**Model:** Free to swipe, $3.99 one-time to delete

**Why this works:**
- Sunk cost: user already invested time swiping
- Concrete value: "2.3GB" is visible, tangible
- One-time is fair: utility app, not recurring use
- No workarounds: delete list only exists in app memory

**Risk mitigation:** Show price before swiping starts so users know the deal upfront.

---

## MVP Features (2-3 weeks)

### Core
- [ ] Folder picker with SAF integration
- [ ] Swipe card UI with thumbnails
- [ ] Track to-delete list in memory
- [ ] Running counter during swiping
- [ ] End screen with thumbnail grid
- [ ] Paywall screen
- [ ] IAP integration
- [ ] Batch delete functionality
- [ ] Success animation

### Not MVP (Later)
- [ ] Multiple folders
- [ ] "Move to folder" gesture (swipe up?)
- [ ] Quick folders (Receipts, Work, etc.)
- [ ] Stats/history
- [ ] Sort by date/size/type
- [ ] Filter by file type

---

## File Preview Support

| Type | Preview | Via |
|------|---------|-----|
| Images | Actual thumbnail | thumbnailer |
| PDFs | First page render | thumbnailer/pdfrx |
| Excel/ODS | First sheet | thumbnailer |
| Word, PPT | Icon | thumbnailer |
| Archives (zip, etc.) | Icon | thumbnailer |
| Code files | Icon | thumbnailer |
| APK | App icon + name | Custom extraction |
| Unknown | Default icon + size | Fallback |

---

## Revenue Projection (Conservative)

| Metric | Estimate |
|--------|----------|
| Price | $3.99 |
| Downloads/month | 200-500 |
| Conversion rate | 10-15% |
| Monthly revenue | $80-300 |
| Annual revenue | $1,000-3,600 |

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Rage uninstalls at paywall | Show price upfront before swiping |
| Low conversion | Killer animation, clear value display |
| SAF permission friction | Good onboarding tutorial |
| Large folder performance | Lazy loading, pagination |

---

## App Store Details

**Name ideas:**
- SwipeClear
- FileSweep
- Swipe & Delete
- CleanSwipe

**Category:** Tools / Utilities

**Keywords:** file cleaner, downloads cleaner, storage cleaner, swipe delete, document organizer

---

## Design Notes

### Swipe Card
- Large thumbnail/icon (70% of card)
- Filename (truncated if long)
- File size + date modified
- File type badge

### End Screen Animation Ideas
- Files shrink and whoosh into black hole
- Confetti explosion + storage meter going down
- Paper shredder animation
- Haptic feedback on delete

### Colors
- Keep = Green glow on swipe right
- Delete = Red glow on swipe left
- Neutral = Clean white/dark theme

---

## Created

- **Date:** 2026-02-15
- **Origin:** Reddit research for "apps that solve problems for 10-100 people"
- **Source:** r/androidapps request for Tinder-style document cleaner
