document.addEventListener('DOMContentLoaded', () => {
    const slides = document.querySelectorAll('.slide');
    const nextBtn = document.getElementById('nextBtn');
    const prevBtn = document.getElementById('prevBtn');
    const currentNumDisplay = document.getElementById('currentNum');
    const progressBar = document.getElementById('progressBar');
    
    let currentSlide = 0;

    function updatePresentation() {
        slides.forEach((slide, index) => {
            slide.classList.remove('active');
            if (index === currentSlide) {
                slide.classList.add('active');
            }
        });

        // Update UI
        currentNumDisplay.textContent = currentSlide + 1;
        progressBar.style.width = ((currentSlide + 1) / slides.length) * 100 + '%';

        // Scroll to top if needed
        window.scrollTo(0, 0);
    }

    nextBtn.addEventListener('click', () => {
        if (currentSlide < slides.length - 1) {
            currentSlide++;
            updatePresentation();
        }
    });

    prevBtn.addEventListener('click', () => {
        if (currentSlide > 0) {
            currentSlide--;
            updatePresentation();
        }
    });

    // Keyboard Navigation
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowRight' || e.key === ' ') {
            if (currentSlide < slides.length - 1) {
                currentSlide++;
                updatePresentation();
            }
        }
        if (e.key === 'ArrowLeft') {
            if (currentSlide > 0) {
                currentSlide--;
                updatePresentation();
            }
        }
    });

    // Touch Support (Simple swipe)
    let touchStartX = 0;
    let touchEndX = 0;
    
    document.addEventListener('touchstart', e => {
        touchStartX = e.changedTouches[0].screenX;
    });

    document.addEventListener('touchend', e => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    });

    function handleSwipe() {
        if (touchEndX < touchStartX - 50) {
            if (currentSlide < slides.length - 1) {
                currentSlide++;
                updatePresentation();
            }
        }
        if (touchEndX > touchStartX + 50) {
            if (currentSlide > 0) {
                currentSlide--;
                updatePresentation();
            }
        }
    }

    // Initialize
    updatePresentation();
});
