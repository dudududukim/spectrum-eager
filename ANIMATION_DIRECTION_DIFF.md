# 애니메이션 방향 제어 기능 - Unified Diff

## 변경된 파일 목록

1. `_config.yml` - `direction` 설정 추가
2. `_includes/gallery-track.html` - 방향 로직 및 CSS 변수 주입
3. `_includes/music-gallery-track.html` - 방향 로직 및 CSS 변수 주입
4. `_sass/_layouts.scss` - `animation-direction` 속성 추가

## Unified Diff

### A) _config.yml

```diff
--- a/_config.yml
+++ b/_config.yml
@@ -143,9 +143,11 @@
 # Only global section settings should be here
 # Renamed from 'sections' to 'section_settings' to avoid conflict with collections.sections
 section_settings:
   gallery_track:
     card_duration: 10      # Seconds per card (controls animation speed)
+    direction: left         # Animation direction: 'left' or 'right'
   
   music_gallery:
     card_duration: 10      # Seconds per card (controls animation speed)
+    direction: left         # Animation direction: 'left' or 'right'
     link_text: "🎶 Duhyeon's pick"
```

### B) _includes/gallery-track.html

```diff
--- a/_includes/gallery-track.html
+++ b/_includes/gallery-track.html
@@ -4,7 +4,13 @@
 {% assign recent_films = films %}
 
-{% comment %} Load card_duration from config.yml - same pattern as image_count {% endcomment %}
+{% comment %} Load card_duration and direction from config.yml {% endcomment %}
 {% assign card_duration = site.section_settings.gallery_track.card_duration | default: 8 | plus: 0 %}
-<!-- DEBUG card_duration={{ card_duration }} -->
+{% assign direction = site.section_settings.gallery_track.direction | default: 'left' | downcase %}
+{% assign track_direction = 'normal' %}
+{% if direction == 'right' %}
+  {% assign track_direction = 'reverse' %}
+{% endif %}
+<!-- DEBUG card_duration={{ card_duration }}, direction={{ direction }} -->
 
 {% comment %} Calculate animation duration for constant speed
   Formula: total_duration = item_count × card_duration
@@ -25,7 +31,7 @@
                     {% if recent_films.size >= 3 %}
                         <!-- For seamless infinite scroll, duplicate items when we have enough images -->
-                        <div class="gallery-track gallery-track-animated" style="--track-duration: {{ animation_duration }}s;">
+                        <div class="gallery-track gallery-track-animated" style="--track-duration: {{ animation_duration }}s; --track-direction: {{ track_direction }};">
                             {% for i in (1..2) %}
                                 {% for film in recent_films %}
```

### C) _includes/music-gallery-track.html

```diff
--- a/_includes/music-gallery-track.html
+++ b/_includes/music-gallery-track.html
@@ -3,7 +3,13 @@
 {% assign featured_musics = all_musics %}
 
-{% comment %} Load card_duration from config.yml {% endcomment %}
+{% comment %} Load card_duration and direction from config.yml {% endcomment %}
 {% assign card_duration = site.section_settings.music_gallery.card_duration | default: 5 | plus: 0 %}
-<!-- DEBUG card_duration={{ card_duration }} -->
+{% assign direction = site.section_settings.music_gallery.direction | default: 'left' | downcase %}
+{% assign track_direction = 'normal' %}
+{% if direction == 'right' %}
+  {% assign track_direction = 'reverse' %}
+{% endif %}
+<!-- DEBUG card_duration={{ card_duration }}, direction={{ direction }} -->
 
 {% comment %} Calculate animation duration for constant speed
   Formula: total_duration = item_count × card_duration
@@ -19,7 +25,7 @@
             {% if featured_musics.size > 0 %}
                 {% if featured_musics.size >= 3 %}
-                    <div class="music-gallery-track music-gallery-track-animated" style="--track-duration: {{ animation_duration }}s;">
+                    <div class="music-gallery-track music-gallery-track-animated" style="--track-duration: {{ animation_duration }}s; --track-direction: {{ track_direction }};">
                         {% for i in (1..4) %}
                             {% for music in featured_musics %}
```

### D) _sass/_layouts.scss

```diff
--- a/_sass/_layouts.scss
+++ b/_sass/_layouts.scss
@@ -795,6 +795,7 @@
     // Animated track (3+ items)
     &.gallery-track-animated {
       animation: scroll-horizontal linear infinite;
       animation-duration: var(--track-duration, 45s);
+      animation-direction: var(--track-direction, normal);
       
       // &:hover {
       //   animation-play-state: paused;
@@ -1047,6 +1048,7 @@
     &.music-gallery-track-animated {
       animation: scroll-horizontal linear infinite;
       animation-duration: var(--track-duration, 30s);
+      animation-direction: var(--track-direction, normal);
       
       // &:hover {
       //   animation-play-state: paused;
```

## 검증 방법

### 1. Jekyll 서버 재실행
```bash
bundle exec jekyll serve
```

### 2. 페이지 소스에서 DEBUG 값 확인
브라우저에서 페이지 소스 보기 또는 Elements 패널에서:
- `.gallery-track-animated` 요소 근처에 `<!-- DEBUG card_duration=10, direction=left -->` 주석 확인
- `.music-gallery-track-animated` 요소 근처에 `<!-- DEBUG card_duration=10, direction=left -->` 주석 확인

### 3. DevTools에서 CSS 변수 및 animation-direction 확인

```javascript
// 갤러리 트랙 확인
const gallery = document.querySelector('.gallery-track-animated');
if (gallery) {
    const computed = getComputedStyle(gallery);
    console.log('Gallery Track:');
    console.log('  --track-duration:', computed.getPropertyValue('--track-duration').trim());
    console.log('  --track-direction:', computed.getPropertyValue('--track-direction').trim());
    console.log('  animation-direction:', computed.animationDirection);
}

// 음악 갤러리 트랙 확인
const music = document.querySelector('.music-gallery-track-animated');
if (music) {
    const computed = getComputedStyle(music);
    console.log('Music Gallery Track:');
    console.log('  --track-duration:', computed.getPropertyValue('--track-duration').trim());
    console.log('  --track-direction:', computed.getPropertyValue('--track-direction').trim());
    console.log('  animation-direction:', computed.animationDirection);
}
```

**설정 변경 테스트**:
1. `_config.yml`에서 `gallery_track.direction: right`로 변경
2. Jekyll 재빌드
3. 위 스크립트 실행 → `animation-direction`이 `reverse`로 변경되는지 확인
4. 시각적으로 갤러리가 오른쪽으로 스크롤되는지 확인

