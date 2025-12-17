/**
 * Reading Progress Bar
 * Shows reading progress as a thin colored line below the navigation
 */

(function() {
    'use strict';

    function initReadingProgress() {
        const progressBar = document.getElementById('reading-progress');
        
        if (!progressBar) {
            console.warn('Reading progress bar element not found');
            return;
        }

        // 네비게이션의 실제 높이를 계산해서 진행바를 바로 아래에 배치
        const nav = document.querySelector('.site-navigation');
        let navHeight = '6rem'; // 기본값
        
        if (nav) {
            const navRect = nav.getBoundingClientRect();
            navHeight = navRect.height + 'px';
        } else {
            // 네비게이션을 찾을 수 없으면 반응형에 따라 설정
            navHeight = window.innerWidth <= 767 ? '5.5rem' : (window.innerWidth <= 1023 ? '5.75rem' : '6rem');
        }
        
        // Force set styles with setProperty to override !important
        progressBar.style.setProperty('position', 'fixed', 'important');
        progressBar.style.setProperty('top', navHeight, 'important');
        progressBar.style.setProperty('left', '0', 'important');
        progressBar.style.setProperty('right', '0', 'important');
        progressBar.style.setProperty('z-index', '999', 'important');
        progressBar.style.setProperty('width', '0%', 'important');
        progressBar.style.setProperty('height', '3px', 'important');
        progressBar.style.setProperty('display', 'block', 'important');
        progressBar.style.setProperty('pointer-events', 'none', 'important');
        
        // Get primary color from CSS or use fallback
        const primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--primary-color').trim() || '#3498db';
        progressBar.style.setProperty('background', primaryColor, 'important');
        
        // Debug: Log to console
        console.log('Reading progress bar initialized:', {
            element: progressBar,
            position: progressBar.style.position,
            top: progressBar.style.top,
            zIndex: progressBar.style.zIndex
        });

        function updateProgress() {
            // Get scroll position (more reliable method)
            const winScroll = document.documentElement.scrollTop || document.body.scrollTop || window.pageYOffset;
            
            // Calculate total scrollable height
            const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            
            // Calculate scroll percentage
            const scrolled = height > 0 ? (winScroll / height) * 100 : 0;
            
            // Update progress bar width with clamping
            const width = Math.min(100, Math.max(0, scrolled));
            progressBar.style.setProperty('width', width + '%', 'important');
        }

        // Throttle scroll events for better performance
        let ticking = false;
        
        function handleScroll() {
            if (!ticking) {
                window.requestAnimationFrame(() => {
                    updateProgress();
                    ticking = false;
                });
                ticking = true;
            }
        }

        // Initial update
        updateProgress();

        // Listen for scroll events
        window.addEventListener('scroll', handleScroll, { passive: true });
        
        // Update on resize (in case content height changes)
        window.addEventListener('resize', () => {
            // 네비게이션 높이 재계산
            const nav = document.querySelector('.site-navigation');
            if (nav) {
                const navRect = nav.getBoundingClientRect();
                progressBar.style.setProperty('top', navRect.height + 'px', 'important');
            }
            updateProgress();
        }, { passive: true });

        // Update when content loads (for dynamic content)
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', updateProgress);
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initReadingProgress);
    } else {
        // If DOM is already loaded, initialize immediately
        initReadingProgress();
    }

    // Also initialize after a short delay to ensure everything is ready
    setTimeout(initReadingProgress, 100);
})();

