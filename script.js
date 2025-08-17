// Dinah Bons Website - Interactive JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu functionality
    initializeMobileMenu();
    
    // Smooth scrolling for anchor links
    initializeSmoothScrolling();
    
    // Active navigation highlighting
    initializeActiveNavigation();
    
    // Accessibility enhancements
    initializeAccessibility();
    
    // Performance optimizations
    initializePerformanceOptimizations();
});

// Mobile Menu Functionality
function initializeMobileMenu() {
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (mobileMenuToggle && navMenu) {
        mobileMenuToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            
            // Update aria-expanded attribute for accessibility
            const isExpanded = navMenu.classList.contains('active');
            mobileMenuToggle.setAttribute('aria-expanded', isExpanded);
            
            // Update button text for screen readers
            mobileMenuToggle.innerHTML = isExpanded ? '✕' : '☰';
        });
        
        // Close mobile menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!mobileMenuToggle.contains(event.target) && !navMenu.contains(event.target)) {
                navMenu.classList.remove('active');
                mobileMenuToggle.setAttribute('aria-expanded', 'false');
                mobileMenuToggle.innerHTML = '☰';
            }
        });
        
        // Close mobile menu when pressing Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape' && navMenu.classList.contains('active')) {
                navMenu.classList.remove('active');
                mobileMenuToggle.setAttribute('aria-expanded', 'false');
                mobileMenuToggle.innerHTML = '☰';
                mobileMenuToggle.focus();
            }
        });
        
        // Close mobile menu when clicking on a nav link
        const navLinks = navMenu.querySelectorAll('a');
        navLinks.forEach(link => {
            link.addEventListener('click', function() {
                navMenu.classList.remove('active');
                mobileMenuToggle.setAttribute('aria-expanded', 'false');
                mobileMenuToggle.innerHTML = '☰';
            });
        });
    }
}

// Smooth Scrolling for Anchor Links
function initializeSmoothScrolling() {
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(event) {
            const targetId = this.getAttribute('href');
            
            // Skip if it's just "#" or empty
            if (targetId === '#' || targetId === '') return;
            
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                event.preventDefault();
                
                // Calculate offset for fixed header
                const headerHeight = document.querySelector('header').offsetHeight;
                const targetPosition = targetElement.offsetTop - headerHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
                
                // Update URL without jumping
                history.pushState(null, null, targetId);
                
                // Focus the target element for accessibility
                targetElement.setAttribute('tabindex', '-1');
                targetElement.focus();
            }
        });
    });
}

// Active Navigation Highlighting
function initializeActiveNavigation() {
    const navLinks = document.querySelectorAll('.nav-menu a');
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    
    navLinks.forEach(link => {
        const linkPage = link.getAttribute('href');
        
        // Remove existing active classes
        link.classList.remove('active');
        
        // Add active class to current page
        if (linkPage === currentPage || 
            (currentPage === '' && linkPage === 'index.html') ||
            (currentPage === 'index.html' && linkPage === 'index.html')) {
            link.classList.add('active');
        }
    });
}

// Accessibility Enhancements
function initializeAccessibility() {
    // Add skip link functionality
    addSkipLink();
    
    // Enhance focus management
    enhanceFocusManagement();
    
    // Add ARIA labels where needed
    addAriaLabels();
    
    // Improve keyboard navigation
    improveKeyboardNavigation();
}

function addSkipLink() {
    // Create skip link if it doesn't exist
    if (!document.querySelector('.skip-link')) {
        const skipLink = document.createElement('a');
        skipLink.href = '#main-content';
        skipLink.className = 'skip-link';
        skipLink.textContent = 'Skip to main content';
        skipLink.style.cssText = `
            position: absolute;
            top: -40px;
            left: 6px;
            background: var(--primary-color);
            color: white;
            padding: 8px;
            text-decoration: none;
            border-radius: 4px;
            z-index: 1001;
            transition: top 0.3s;
        `;
        
        // Show on focus
        skipLink.addEventListener('focus', function() {
            this.style.top = '6px';
        });
        
        skipLink.addEventListener('blur', function() {
            this.style.top = '-40px';
        });
        
        document.body.insertBefore(skipLink, document.body.firstChild);
        
        // Add main content ID if it doesn't exist
        const mainContent = document.querySelector('main') || document.querySelector('.hero');
        if (mainContent && !mainContent.id) {
            mainContent.id = 'main-content';
        }
    }
}

function enhanceFocusManagement() {
    // Ensure focus is visible
    const focusableElements = document.querySelectorAll(
        'a, button, input, textarea, select, [tabindex]:not([tabindex="-1"])'
    );
    
    focusableElements.forEach(element => {
        element.addEventListener('focus', function() {
            this.style.outline = '2px solid var(--secondary-color)';
            this.style.outlineOffset = '2px';
        });
        
        element.addEventListener('blur', function() {
            this.style.outline = '';
            this.style.outlineOffset = '';
        });
    });
}

function addAriaLabels() {
    // Add aria-labels to buttons without text
    const buttons = document.querySelectorAll('button:not([aria-label])');
    buttons.forEach(button => {
        if (!button.textContent.trim()) {
            button.setAttribute('aria-label', 'Menu button');
        }
    });
    
    // Add aria-labels to links that open in new windows
    const externalLinks = document.querySelectorAll('a[target="_blank"]');
    externalLinks.forEach(link => {
        if (!link.getAttribute('aria-label')) {
            link.setAttribute('aria-label', link.textContent + ' (opens in new window)');
        }
    });
}

function improveKeyboardNavigation() {
    // Handle Enter key on clickable elements
    const clickableElements = document.querySelectorAll('[role="button"], .card, .timeline-item');
    
    clickableElements.forEach(element => {
        element.addEventListener('keydown', function(event) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                this.click();
            }
        });
    });
}

// Performance Optimizations
function initializePerformanceOptimizations() {
    // Lazy loading for images
    implementLazyLoading();
    
    // Optimize scroll events
    optimizeScrollEvents();
    
    // Preload critical resources
    preloadCriticalResources();
}

function implementLazyLoading() {
    // Add intersection observer for images
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    if (img.dataset.src) {
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                        observer.unobserve(img);
                    }
                }
            });
        });
        
        const lazyImages = document.querySelectorAll('img[data-src]');
        lazyImages.forEach(img => imageObserver.observe(img));
    }
}

function optimizeScrollEvents() {
    let ticking = false;
    
    function updateScrollPosition() {
        // Add scroll-based functionality here if needed
        ticking = false;
    }
    
    window.addEventListener('scroll', function() {
        if (!ticking) {
            requestAnimationFrame(updateScrollPosition);
            ticking = true;
        }
    });
}

function preloadCriticalResources() {
    // Preload critical CSS and fonts
    const criticalResources = [
        { rel: 'preload', href: 'style.css', as: 'style' }
    ];
    
    criticalResources.forEach(resource => {
        const link = document.createElement('link');
        Object.keys(resource).forEach(key => {
            link[key] = resource[key];
        });
        document.head.appendChild(link);
    });
}

// Utility Functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function throttle(func, limit) {
    let inThrottle;
    return function() {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// Form Enhancement (if forms are added later)
function enhanceForms() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        // Add form validation
        form.addEventListener('submit', function(event) {
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.classList.add('error');
                    
                    // Add error message if it doesn't exist
                    if (!field.nextElementSibling || !field.nextElementSibling.classList.contains('error-message')) {
                        const errorMessage = document.createElement('span');
                        errorMessage.className = 'error-message';
                        errorMessage.textContent = 'This field is required';
                        errorMessage.style.color = 'var(--secondary-color)';
                        errorMessage.style.fontSize = '0.9rem';
                        field.parentNode.insertBefore(errorMessage, field.nextSibling);
                    }
                } else {
                    field.classList.remove('error');
                    const errorMessage = field.nextElementSibling;
                    if (errorMessage && errorMessage.classList.contains('error-message')) {
                        errorMessage.remove();
                    }
                }
            });
            
            if (!isValid) {
                event.preventDefault();
            }
        });
        
        // Real-time validation
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.classList.add('error');
                } else {
                    this.classList.remove('error');
                    const errorMessage = this.nextElementSibling;
                    if (errorMessage && errorMessage.classList.contains('error-message')) {
                        errorMessage.remove();
                    }
                }
            });
        });
    });
}

// Analytics and Tracking (Privacy-Friendly)
function initializeAnalytics() {
    // Only track if user consents (implement cookie consent if needed)
    if (localStorage.getItem('analytics-consent') === 'true') {
        // Add privacy-friendly analytics here
        trackPageView();
    }
}

function trackPageView() {
    // Simple page view tracking without personal data
    const pageData = {
        page: window.location.pathname,
        timestamp: new Date().toISOString(),
        referrer: document.referrer || 'direct'
    };
    
    // Send to analytics service (implement as needed)
    console.log('Page view:', pageData);
}

// Error Handling
window.addEventListener('error', function(event) {
    console.error('JavaScript error:', event.error);
    // Implement error reporting if needed
});

// Service Worker Registration (for PWA features if needed)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        // Register service worker if available
        // navigator.serviceWorker.register('/sw.js');
    });
}

// Export functions for testing or external use
window.DinahBonsWebsite = {
    initializeMobileMenu,
    initializeSmoothScrolling,
    initializeActiveNavigation,
    initializeAccessibility,
    debounce,
    throttle
};
