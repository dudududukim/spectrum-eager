// Category filtering and pagination functionality
document.addEventListener('DOMContentLoaded', function() {
    // Get pagination size from data attribute or default to 10
    const paginationContainer = document.querySelector('.pagination-sticky');
    const itemsPerPage = paginationContainer ? parseInt(paginationContainer.getAttribute('data-items-per-page')) || 10 : 10;
    
    // Move pagination outside main-content, before footer
    function movePagination() {
        const paginationEl = document.querySelector('.pagination-sticky');
        const footer = document.querySelector('.site-footer');
        const mainContent = document.querySelector('.main-content');
        
        if (paginationEl && footer && mainContent) {
            // Check if pagination is still inside main-content
            if (mainContent.contains(paginationEl)) {
                footer.parentNode.insertBefore(paginationEl, footer);
            }
        }
    }
    
    // Move immediately and after a short delay to ensure DOM is ready
    movePagination();
    setTimeout(movePagination, 100);

    const techBites = document.querySelectorAll('.tech-bite-card');
    const filterButtons = document.querySelectorAll('.filter-btn');
    let currentPage = 1;
    let currentCategory = 'all';
    
    // 페이지별 스크롤 위치 저장
    const scrollPositions = {};

    // Category filtering functionality
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Update active button
            filterButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Update current category
            currentCategory = this.getAttribute('data-category');
            currentPage = 1; // Reset to first page when filtering
            
            updateDisplay();
        });
    });

    // Pagination functionality
    const paginationNumbers = document.getElementById('pagination-numbers');

    function renderPagination() {
        const filteredTechBites = getFilteredTechBites();
        const totalPages = Math.ceil(filteredTechBites.length / itemsPerPage);
        
        if (!paginationNumbers || totalPages <= 1) {
            if (paginationNumbers) paginationNumbers.innerHTML = '';
            return;
        }

        let html = '';
        const maxVisible = 7; // 최대 표시할 페이지 번호 수
        
        if (totalPages <= maxVisible) {
            // 모든 페이지 표시
            for (let i = 1; i <= totalPages; i++) {
                const isActive = i === currentPage;
                html += `<button class="pagination-number ${isActive ? 'active' : ''}" data-page="${i}">${i}</button>`;
            }
        } else {
            // 첫 페이지
            if (currentPage <= 3) {
                for (let i = 1; i <= 4; i++) {
                    const isActive = i === currentPage;
                    html += `<button class="pagination-number ${isActive ? 'active' : ''}" data-page="${i}">${i}</button>`;
                }
                html += `<span class="pagination-ellipsis">...</span>`;
                html += `<button class="pagination-number" data-page="${totalPages}">${totalPages}</button>`;
            }
            // 마지막 페이지
            else if (currentPage >= totalPages - 2) {
                html += `<button class="pagination-number" data-page="1">1</button>`;
                html += `<span class="pagination-ellipsis">...</span>`;
                for (let i = totalPages - 3; i <= totalPages; i++) {
                    const isActive = i === currentPage;
                    html += `<button class="pagination-number ${isActive ? 'active' : ''}" data-page="${i}">${i}</button>`;
                }
            }
            // 중간 페이지
            else {
                html += `<button class="pagination-number" data-page="1">1</button>`;
                html += `<span class="pagination-ellipsis">...</span>`;
                for (let i = currentPage - 1; i <= currentPage + 1; i++) {
                    const isActive = i === currentPage;
                    html += `<button class="pagination-number ${isActive ? 'active' : ''}" data-page="${i}">${i}</button>`;
                }
                html += `<span class="pagination-ellipsis">...</span>`;
                html += `<button class="pagination-number" data-page="${totalPages}">${totalPages}</button>`;
            }
        }
        
        paginationNumbers.innerHTML = html;
        
        // 페이지 번호 클릭 이벤트
        paginationNumbers.querySelectorAll('.pagination-number').forEach(btn => {
            btn.addEventListener('click', function() {
                // 현재 페이지의 스크롤 위치 저장
                scrollPositions[currentPage] = window.pageYOffset || document.documentElement.scrollTop;
                
                const newPage = parseInt(this.getAttribute('data-page'));
                currentPage = newPage;
                
                // 페이지 변경
                updateDisplay();
                
                // 저장된 스크롤 위치로 복원 (약간의 지연으로 DOM 업데이트 대기)
                setTimeout(() => {
                    if (scrollPositions[currentPage] !== undefined) {
                        window.scrollTo({
                            top: scrollPositions[currentPage],
                            behavior: 'auto' // 즉시 이동
                        });
                    } else {
                        // 저장된 위치가 없으면 페이지 상단으로
                        window.scrollTo({
                            top: 0,
                            behavior: 'auto'
                        });
                    }
                }, 50);
            });
        });
    }

    function getFilteredTechBites() {
        if (currentCategory === 'all') {
            return Array.from(techBites);
        }
        return Array.from(techBites).filter(card => {
            // Check data-categories attribute (comma-separated list)
            const categories = card.getAttribute('data-categories');
            if (categories) {
                const categoryList = categories.split(',').map(c => c.trim().toLowerCase());
                return categoryList.includes(currentCategory.toLowerCase());
            }
            // If no categories, don't show in filtered view
            return false;
        });
    }

    function updateDisplay() {
        const filteredTechBites = getFilteredTechBites();
        const totalPages = Math.ceil(filteredTechBites.length / itemsPerPage);
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;

        // Hide all items first
        techBites.forEach(card => {
            card.style.display = 'none';
        });

        // Show filtered items for current page
        filteredTechBites.slice(startIndex, endIndex).forEach(card => {
            card.style.display = 'block';
        });

        // Update pagination
        renderPagination();
        // Ensure pagination is in correct position after update
        movePagination();
    }

    // Initial display
    updateDisplay();
    renderPagination();
    movePagination();
});

