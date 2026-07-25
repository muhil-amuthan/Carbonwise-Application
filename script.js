// CarbonWise Pitch Deck Navigation & Interactions

document.addEventListener("DOMContentLoaded", () => {
    // Initialize Lucide Icons
    lucide.createIcons();

    // Slide State
    let currentSlide = 1;
    const totalSlides = 14;

    const slides = document.querySelectorAll(".slide");
    const progressBar = document.getElementById("progressBar");
    const slideIndicator = document.getElementById("slideIndicator");
    const prevBtn = document.getElementById("prevBtn");
    const nextBtn = document.getElementById("nextBtn");

    // Initialize Viewport
    updateSlideView();

    // Navigation function
    function goToSlide(index) {
        if (index < 1) index = 1;
        if (index > totalSlides) index = totalSlides;

        currentSlide = index;
        updateSlideView();
        triggerSlideAnimations(currentSlide);
    }

    function updateSlideView() {
        slides.forEach((slide) => {
            const idx = parseInt(slide.getAttribute("data-slide-index"));
            slide.classList.remove("active", "prev-slide");
            
            if (idx === currentSlide) {
                slide.classList.add("active");
            } else if (idx < currentSlide) {
                slide.classList.add("prev-slide");
            }
        });

        // Update progress bar
        const progressPercent = (currentSlide / totalSlides) * 100;
        progressBar.style.width = `${progressPercent}%`;

        // Update control slide counter
        slideIndicator.textContent = `${String(currentSlide).padStart(2, "0")} / ${String(totalSlides).padStart(2, "0")}`;
    }

    // Trigger animations when landing on specific slides
    function triggerSlideAnimations(slideIndex) {
        // Slide 10: KPI Counters
        if (slideIndex === 10) {
            animateKpis();
        }

        // Slide 12: Roadmap Progress Bar
        if (slideIndex === 12) {
            animateRoadmapTimeline();
        }

        // Slide 1: Re-trigger energy graph scaling
        if (slideIndex === 1) {
            animateEnergyGraph();
        }
    }

    // SLIDE 1: Energy Graph Simulation Animation
    function animateEnergyGraph() {
        const bars = document.querySelectorAll(".energy-graph-sim .graph-bar");
        bars.forEach((bar) => {
            const targetHeight = bar.style.height;
            bar.style.height = "0%";
            setTimeout(() => {
                bar.style.height = targetHeight;
            }, 100);
        });
    }

    // SLIDE 10: KPI Counter Animation
    let kpiAnimated = false;
    function animateKpis() {
        const counters = document.querySelectorAll(".kpi-val");
        const radials = document.querySelectorAll(".radial-stroke");

        counters.forEach((counter, idx) => {
            const target = parseInt(counter.getAttribute("data-target"));
            let current = 0;
            const duration = 1200; // ms
            const stepTime = Math.abs(Math.floor(duration / target));

            // Reset
            counter.textContent = "0%";
            
            const timer = setInterval(() => {
                current += 1;
                counter.textContent = `${current}%`;
                
                // Animate radial svg circle offsets
                // Circle perimeter is 251.2. The formula for offset is perimeter - (percent/100)*perimeter
                if (radials[idx]) {
                    const offset = 251.2 - (current / 100) * 251.2;
                    radials[idx].style.strokeDashoffset = offset;
                }

                if (current >= target) {
                    counter.textContent = `${target}%`;
                    clearInterval(timer);
                }
            }, stepTime);
        });
    }

    // SLIDE 11: Business Model Wheel Interactive Quadrants
    const wheelSegments = document.querySelectorAll(".wheel-segment");
    const detailTitle = document.getElementById("modelDetailTitle");
    const detailText = document.getElementById("modelDetailText");

    const businessModelsCopy = {
        b2c: {
            title: "B2C Subscription model",
            text: "Premium smart home features, advanced EV charging automations, and carbon-reduction notification preferences. Managed through a micro-subscription model starting at $2.99/month for active households."
        },
        b2g: {
            title: "B2G Municipal Licensing",
            text: "Municipal and city-wide licensing options. Grants municipal bodies full dashboard view access to GIS heatmaps, sensor node data feeds, environmental data APIs, and urban pollution hotspot alerts."
        },
        b2b: {
            title: "B2B SaaS Analytics",
            text: "Enterprise API integrations for campuses, commercial warehouses, and manufacturing facilities looking to track compliance standards, optimize HVAC usage, and automate energy scheduling."
        },
        hw: {
            title: "Hardware Deployment",
            text: "Direct provision of custom, ESP32-based ultra-low-cost air quality and carbon sensor nodes to municipal corporations and factories for rapid physical grid expansion."
        }
    };

    wheelSegments.forEach((segment) => {
        segment.addEventListener("click", () => {
            // Remove active style from all segments
            wheelSegments.forEach((s) => s.classList.remove("active-segment"));
            
            // Add active style to clicked segment
            segment.classList.add("active-segment");

            // Extract model type and update text
            const modelType = segment.getAttribute("data-model");
            const copy = businessModelsCopy[modelType];
            
            if (copy) {
                detailTitle.textContent = copy.title;
                detailText.textContent = copy.text;
                
                // Add highlight blink effect to copy container
                const card = document.getElementById("modelDetail");
                card.style.borderColor = "var(--accent-green)";
                setTimeout(() => {
                    card.style.borderColor = "var(--border-color)";
                }, 400);
            }
        });
    });

    // SLIDE 12: Roadmap Timeline Animation
    function animateRoadmapTimeline() {
        const progressBarTimeline = document.querySelector(".timeline-progress");
        const nodes = document.querySelectorAll(".timeline-node");
        
        progressBarTimeline.style.width = "0%";
        nodes.forEach(n => n.classList.remove("active-node"));

        setTimeout(() => {
            progressBarTimeline.style.width = "90%";
        }, 200);

        // Sequentially highlight the nodes as the progress line grows
        nodes.forEach((node, idx) => {
            setTimeout(() => {
                node.classList.add("active-node");
            }, 300 + (idx * 250));
        });
    }

    // Keyboard Navigation Handlers
    document.addEventListener("keydown", (e) => {
        if (e.key === "ArrowRight" || e.key === "Space" || e.code === "Space") {
            e.preventDefault();
            goToSlide(currentSlide + 1);
        } else if (e.key === "ArrowLeft") {
            e.preventDefault();
            goToSlide(currentSlide - 1);
        }
    });

    // Control Panel Button Handlers
    prevBtn.addEventListener("click", () => goToSlide(currentSlide - 1));
    nextBtn.addEventListener("click", () => goToSlide(currentSlide + 1));

    // Touch Swiping Handlers
    let touchStartX = 0;
    let touchEndX = 0;
    
    document.addEventListener("touchstart", (e) => {
        touchStartX = e.changedTouches[0].screenX;
    }, false);

    document.addEventListener("touchend", (e) => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    }, false);

    function handleSwipe() {
        const threshold = 50; // swipe length in pixels
        if (touchStartX - touchEndX > threshold) {
            // Swiped Left -> next slide
            goToSlide(currentSlide + 1);
        } else if (touchEndX - touchStartX > threshold) {
            // Swiped Right -> prev slide
            goToSlide(currentSlide - 1);
        }
    }
});
