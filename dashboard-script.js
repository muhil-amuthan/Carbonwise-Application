// CarbonWise Product Model Interactivity

document.addEventListener("DOMContentLoaded", () => {
    // Initialize Lucide Icons
    lucide.createIcons();

    // Elements
    const btnConsumer = document.getElementById("btnConsumer");
    const btnCity = document.getElementById("btnCity");
    const consumerPortal = document.getElementById("consumerPortal");
    const cityPortal = document.getElementById("cityPortal");
    const pageTitle = document.getElementById("pageTitle");
    const pageDescription = document.getElementById("pageDescription");
    const toastContainer = document.getElementById("toastContainer");

    // Header values
    const headerIntensity = document.getElementById("headerIntensity");

    // ==========================================
    // TAB SWITCHING NAVIGATION
    // ==========================================
    btnConsumer.addEventListener("click", () => {
        btnConsumer.classList.add("active");
        btnCity.classList.remove("active");
        consumerPortal.classList.add("active");
        cityPortal.classList.remove("active");
        pageTitle.textContent = "Consumer Portal";
        pageDescription.textContent = "Optimize household appliance runtime based on real-time grid carbon forecast.";
        headerIntensity.textContent = "210 g/kWh";
        headerIntensity.className = "val warning";
    });

    btnCity.addEventListener("click", () => {
        btnCity.classList.add("active");
        btnConsumer.classList.remove("active");
        cityPortal.classList.add("active");
        consumerPortal.classList.remove("active");
        pageTitle.textContent = "City Carbon Grid Portal";
        pageDescription.textContent = "Low-cost sensor deployment and AI gap-filling emissions mapping.";
        headerIntensity.textContent = "AI Model Active";
        headerIntensity.className = "val accent-green";
        
        // Render GIS grid if not already rendered
        initializeGisMap();
    });

    // ==========================================
    // TOAST NOTIFICATIONS HELPER
    // ==========================================
    function showToast(message, type = "success") {
        const toast = document.createElement("div");
        toast.className = "toast";
        toast.innerHTML = `<i data-lucide="check-circle-2"></i> <span>${message}</span>`;
        toastContainer.appendChild(toast);
        lucide.createIcons({ node: toast });

        // Slide in, wait, then slide out
        setTimeout(() => {
            toast.classList.add("removing");
            setTimeout(() => {
                toast.remove();
            }, 400);
        }, 3000);
    }

    // ==========================================
    // CONSUMER PORTAL PORT (B2C)
    // ==========================================
    const kpiCo2 = document.getElementById("kpiCo2");
    const kpiShifted = document.getElementById("kpiShifted");
    const kpiCost = document.getElementById("kpiCost");

    // Base metrics
    let baseMetrics = {
        co2: 12.4,
        shifted: 48.2,
        cost: 8.95
    };

    // Toggles
    const toggleEv = document.getElementById("toggle-ev");
    const toggleLaundry = document.getElementById("toggle-laundry");
    const toggleHvac = document.getElementById("toggle-hvac");

    // Appliance Card references
    const evStatusText = document.querySelector("#appliance-ev .status-text");
    const evTimeSuggest = document.getElementById("ev-time");
    
    const laundryStatusText = document.querySelector("#appliance-laundry .status-text");
    const laundryTimeSuggest = document.getElementById("laundry-time");
    
    const hvacStatusText = document.querySelector("#appliance-hvac .status-text");
    const hvacTimeSuggest = document.getElementById("hvac-time");

    // Track active automations to adjust KPIs
    let automations = {
        ev: false,
        laundry: false,
        hvac: false
    };

    function updateKpis() {
        let addedCo2 = 0;
        let addedShifted = 0;
        let addedCost = 0;

        if (automations.ev) {
            addedCo2 += 3.4;
            addedShifted += 18.0;
            addedCost += 1.80;
        }
        if (automations.laundry) {
            addedCo2 += 1.2;
            addedShifted += 3.5;
            addedCost += 0.40;
        }
        if (automations.hvac) {
            addedCo2 += 0.9;
            addedShifted += 2.8;
            addedCost += 0.35;
        }

        // Animate counting
        animateMetric(kpiCo2, baseMetrics.co2 + addedCo2, "kg");
        animateMetric(kpiShifted, baseMetrics.shifted + addedShifted, "kWh");
        animateMetric(kpiCost, baseMetrics.cost + addedCost, "USD");
    }

    function animateMetric(element, targetVal, type) {
        let current = parseFloat(element.textContent);
        const diff = targetVal - current;
        if (Math.abs(diff) < 0.05) {
            element.textContent = targetVal.toFixed(type === "USD" ? 2 : 1);
            return;
        }
        
        let steps = 10;
        let stepCount = 0;
        const interval = setInterval(() => {
            current += diff / steps;
            element.textContent = current.toFixed(type === "USD" ? 2 : 1);
            stepCount++;
            if (stepCount >= steps) {
                element.textContent = targetVal.toFixed(type === "USD" ? 2 : 1);
                clearInterval(interval);
            }
        }, 30);
    }

    // EV Toggle listener
    toggleEv.addEventListener("change", () => {
        if (toggleEv.checked) {
            automations.ev = true;
            evStatusText.textContent = "Auto-scheduled (2:00 PM Solar peak)";
            evStatusText.className = "status-text clean";
            evTimeSuggest.textContent = "Time: 2:00 PM";
            evTimeSuggest.style.color = "var(--accent-green)";
            showToast("EV Charging redirected to Solar peak! +3.4kg CO2 Saved");
        } else {
            automations.ev = false;
            evStatusText.textContent = "Charging Now (High carbon period)";
            evStatusText.className = "status-text dirty";
            evTimeSuggest.textContent = "Est: 5:00 PM";
            evTimeSuggest.style.color = "var(--text-secondary)";
            showToast("EV Charging automation disabled.");
        }
        updateKpis();
    });

    // Laundry Toggle listener
    toggleLaundry.addEventListener("change", () => {
        if (toggleLaundry.checked) {
            automations.laundry = true;
            laundryStatusText.textContent = "Auto-scheduled (2:30 PM Clean Energy Window)";
            laundryStatusText.className = "status-text clean";
            laundryTimeSuggest.textContent = "Time: 2:30 PM";
            laundryTimeSuggest.style.color = "var(--accent-green)";
            showToast("Washing Machine auto-scheduled! +1.2kg CO2 Saved");
        } else {
            automations.laundry = false;
            laundryStatusText.textContent = "Waiting for scheduling";
            laundryStatusText.className = "status-text idle";
            laundryTimeSuggest.textContent = "Est: User manual";
            laundryTimeSuggest.style.color = "var(--text-secondary)";
            showToast("Laundry automation disabled.");
        }
        updateKpis();
    });

    // HVAC Toggle listener
    toggleHvac.addEventListener("change", () => {
        if (toggleHvac.checked) {
            automations.hvac = true;
            hvacStatusText.textContent = "Dynamic Eco cycling active";
            hvacStatusText.className = "status-text running";
            hvacTimeSuggest.textContent = "Eco: 23.5°C";
            hvacTimeSuggest.style.color = "var(--accent-cyan)";
            showToast("AC eco-cycling active. Shifting load dynamically!");
        } else {
            automations.hvac = false;
            hvacStatusText.textContent = "Running cooling cycle";
            hvacStatusText.className = "status-text running";
            hvacTimeSuggest.textContent = "Temp: 22°C";
            hvacTimeSuggest.style.color = "var(--text-secondary)";
            showToast("HVAC eco-cycling disabled.");
        }
        updateKpis();
    });


    // ==========================================
    // SMART CITY PORTAL PORT (B2G)
    // ==========================================
    const gisGrid = document.getElementById("gisGrid");
    const toggleCityAI = document.getElementById("toggleCityAI");
    const kpiVirtual = document.getElementById("kpiVirtual");
    const kpiHotspots = document.getElementById("kpiHotspots");
    const kpiHotspotSub = document.getElementById("kpiHotspotSub");
    const mapStatsPanel = document.getElementById("mapStatsPanel");
    
    const telemetryAlpha = document.getElementById("telemetryAlpha");
    const telemetryBeta = document.getElementById("telemetryBeta");

    // Grid coordinates: size 10x10.
    // Index 0 to 99.
    // 4 physical sensor indices
    const physicalSensors = [23, 47, 61, 85];

    // Hotspot central hubs
    const hotspots = {
        alpha: { center: 15, radius: 2.2 },  // Industrial zone hotspot
        beta: { center: 77, radius: 1.8 }    // Traffic intersection hotspot
    };

    let mapInitialized = false;

    function initializeGisMap() {
        if (mapInitialized) return;
        gisGrid.innerHTML = "";
        
        for (let i = 0; i < 100; i++) {
            const cell = document.createElement("div");
            cell.className = "gis-cell";
            cell.setAttribute("data-index", i);
            
            // Check if physical sensor
            if (physicalSensors.includes(i)) {
                cell.classList.add("sensor-physical");
                cell.setAttribute("title", `Physical Node #${physicalSensors.indexOf(i) + 1}`);
            }
            
            gisGrid.appendChild(cell);
        }
        mapInitialized = true;
    }

    // AI Grid scan activation
    toggleCityAI.addEventListener("change", () => {
        const cells = document.querySelectorAll(".gis-cell");
        
        if (toggleCityAI.checked) {
            // Sweep sweep sweep scanning visual
            showToast("AI Spatial Kriging model activated.");
            showToast("2 Hidden carbon hotspots unmasked!");

            // Trigger telemetry panel load
            mapStatsPanel.style.opacity = "1";
            telemetryAlpha.textContent = "485 g/m³ (CRITICAL)";
            telemetryBeta.textContent = "390 g/m³ (MODERATE)";
            
            // Animate KPIs
            animateNumberCounter(kpiVirtual, 36);
            animateNumberCounter(kpiHotspots, 2);
            kpiHotspotSub.textContent = "HOTSPOTS DETECTED!";
            kpiHotspotSub.className = "trend negative";

            // Loop and assign cell colors based on distance to hotspots
            cells.forEach((cell, idx) => {
                // If it is physical sensor, keep it blue/cyan
                if (physicalSensors.includes(idx)) return;

                // Calculate grid coordinate indices (0-9)
                const cellX = idx % 10;
                const cellY = Math.floor(idx / 10);

                // Compute distance to Hotspot Alpha center (row 1, col 5 = index 15)
                const alphaX = 15 % 10;
                const alphaY = Math.floor(15 / 10);
                const distAlpha = Math.sqrt((cellX - alphaX)**2 + (cellY - alphaY)**2);

                // Compute distance to Hotspot Beta center (row 7, col 7 = index 77)
                const betaX = 77 % 10;
                const betaY = Math.floor(77 / 10);
                const distBeta = Math.sqrt((cellX - betaX)**2 + (cellY - betaY)**2);

                // Sweep animation delay from left to right (X coordinate)
                cell.style.transitionDelay = `${cellX * 50}ms`;

                // Set heatmap layer classes based on hotspot vicinity
                if (distAlpha <= hotspots.alpha.radius || distBeta <= hotspots.beta.radius) {
                    cell.classList.add("heat-hotspot");
                } else if (distAlpha <= hotspots.alpha.radius + 1.5 || distBeta <= hotspots.beta.radius + 1.5) {
                    cell.classList.add("heat-mod");
                } else {
                    cell.classList.add("heat-clean");
                }
            });

        } else {
            // Disable AI layer
            showToast("AI spatial layer unloaded.");
            mapStatsPanel.style.opacity = "0.5";
            telemetryAlpha.textContent = "--";
            telemetryBeta.textContent = "--";
            
            animateNumberCounter(kpiVirtual, 0);
            animateNumberCounter(kpiHotspots, 0);
            kpiHotspotSub.textContent = "Hotspots Hidden";
            kpiHotspotSub.className = "trend neutral";

            cells.forEach((cell) => {
                cell.style.transitionDelay = "0ms";
                cell.classList.remove("heat-hotspot", "heat-mod", "heat-clean");
            });
        }
    });

    function animateNumberCounter(element, target) {
        let current = parseInt(element.textContent);
        const diff = target - current;
        if (diff === 0) return;
        
        let val = current;
        const step = diff > 0 ? 1 : -1;
        
        const interval = setInterval(() => {
            val += step;
            element.textContent = val;
            if (val === target) {
                clearInterval(interval);
            }
        }, 15);
    }
});
