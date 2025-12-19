# Remote Theme 사용 가이드

## 현재 구조

- **theme 브랜치**: 테마 코드 (레이아웃, 스타일, JavaScript 등)
- **main 브랜치**: 사용자 사이트 (컨텐츠, 설정 파일)

## 사용 방법

### 1. Theme 브랜치 푸시 (최초 1회)

먼저 theme 브랜치를 GitHub에 푸시해야 합니다:

```bash
# theme 브랜치로 전환
git checkout theme

# 변경사항 커밋
git add .
git commit -m "feat: prepare theme branch for remote theme"

# GitHub에 푸시
git push origin theme
```

### 2. Main 브랜치에서 의존성 설치

```bash
# main 브랜치로 전환
git checkout main

# 의존성 설치
bundle install
```

### 3. 로컬에서 테스트

```bash
# Jekyll 서버 실행
bundle exec jekyll serve

# 브라우저에서 확인
# http://localhost:4000/spectrum-eager/
```

### 4. GitHub Pages 배포

#### 방법 1: GitHub Actions 사용 (권장)

1. `.github/workflows/jekyll.yml` 파일이 있는지 확인
2. GitHub 저장소 Settings > Pages에서 Source를 "GitHub Actions"로 설정
3. main 브랜치에 푸시하면 자동으로 빌드됨

```bash
git add .
git commit -m "feat: configure remote theme"
git push origin main
```

#### 방법 2: 로컬 빌드 후 푸시

```bash
# 빌드
bundle exec jekyll build

# _site 폴더를 gh-pages 브랜치에 푸시
```

## 파일 관리

### 사용자가 관리하는 파일 (main 브랜치)

**컨텐츠:**
- `_posts/` - 블로그 포스트
- `_films/` - 사진 갤러리
- `index.md`, `tech-bites.md`, `films.md` - 페이지 파일

**설정:**
- `_config.yml` - 사이트 설정
- `_data/navigation.yml` - 네비게이션 메뉴
- `_data/sections.yml` - 섹션 정의
- `_sections/*/config.yml` - 섹션별 설정

**이미지:**
- `assets/images/` - 사용자 이미지

### 테마 파일 (theme 브랜치, 자동 로드)

다음 파일들은 remote-theme으로 자동 로드되므로 main 브랜치에 없어도 됩니다:
- `_layouts/`
- `_includes/`
- `_sass/`
- `assets/css/`
- `assets/js/`

## 테마 업데이트

테마를 업데이트하려면:

1. theme 브랜치에서 변경사항 커밋 및 푸시
2. main 브랜치에서 `bundle update jekyll-remote-theme` (필요시)
3. 사이트가 자동으로 새 테마를 사용

## 문제 해결

### 테마가 로드되지 않는 경우

1. theme 브랜치가 GitHub에 푸시되었는지 확인
2. `_config.yml`의 `remote_theme` 설정 확인:
   ```yaml
   remote_theme: dudududukim/spectrum-eager@theme
   ```
3. `Gemfile`에 `jekyll-remote-theme`이 있는지 확인
4. `bundle install` 실행

### 로컬에서 빌드 오류

```bash
# 캐시 삭제 후 재시도
rm -rf .jekyll-cache _site
bundle exec jekyll serve
```

## 다음 단계

1. ✅ theme 브랜치 푸시
2. ✅ bundle install
3. ✅ 로컬 테스트
4. ✅ GitHub Pages 배포

