// CarbonWise Frontend - Complete Modern SPA
const API_BASE = "https://api.carbonwise.in"; // Render backend

let currentUser = null;
let userMap = null;
let managerMap = null;
let userEnergyChart = null;
let managerChart = null;

// ==================== AUTH ====================
function showLogin() {
    document.getElementById("login-form").classList.remove("hidden");
    document.getElementById("register-form").classList.add("hidden");
}

function showRegister() {
    document.getElementById("login-form").classList.add("hidden");
    document.getElementById("register-form").classList.remove("hidden");
}

async function login() {
    const email = document.getElementById("login-email").value.trim();
    const password = document.getElementById("login-password").value.trim();

    try {
        const res = await fetch(`${API_BASE}/api/auth/login`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        if (!res.ok) throw new Error("Invalid email or password");

        const data = await res.json();
        localStorage.setItem("token", data.token);
        currentUser = data.user || { email, role: data.role || "CONSUMER", name: data.name || "User" };

        // Handle demo accounts
        if (email === "admin@carbonwise.com") currentUser.role = "CITY_ADMIN";
        if (email === "user@carbonwise.com") currentUser.role = "CONSUMER";

        enterApp();
    } catch (err) {
        alert(err.message || "Login failed. Please try again.");
    }
}

async function register() {
    const name = document.getElementById("reg-name").value.trim();
    const email = document.getElementById("reg-email").value.trim();
    const password = document.getElementById("reg-password").value.trim();

    try {
        const res = await fetch(`${API_BASE}/api/auth/register`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ name, email, password, role: "CONSUMER" })
        });

        if (!res.ok) throw new Error("Registration failed");

        const data = await res.json();
        alert("Account created successfully! Please log in.");
        showLogin();
    } catch (err) {
        alert(err.message);
    }
}

function logout() {
    localStorage.removeItem("token");
    currentUser = null;
    document.getElementById("app").classList.add("hidden");
    document.getElementById("auth-screen").classList.remove("hidden");
    if (userMap) userMap.remove();
    if (managerMap) managerMap.remove();
}

function enterApp() {
    document.getElementById("auth-screen").classList.add("hidden");
    document.getElementById("app").classList.remove("hidden");

    document.getElementById("user-name").innerText = currentUser.name || currentUser.email.split("@")[0];
    document.getElementById("user-role").innerText = currentUser.role === "CITY_ADMIN" ? "Area Manager" : "User";
    document.getElementById("greeting-name").innerText = currentUser.name || "there";

    setupNavigation();
    showDashboard();
}

// ==================== NAV & DASHBOARDS ====================
function setupNavigation() {
    const tabsContainer = document.getElementById("nav-tabs");
    tabsContainer.innerHTML = "";

    if (currentUser.role === "CITY_ADMIN") {
        tabsContainer.innerHTML = `
            <button class="nav-tab active" onclick="showDashboard()">Overview</button>
            <button class="nav-tab" onclick="showDashboard()">Homes</button>
        `;
    } else {
        tabsContainer.innerHTML = `
            <button class="nav-tab active" onclick="showDashboard()">Home</button>
            <button class="nav-tab" onclick="showDashboard()">Insights</button>
        `;
    }
}

function showDashboard() {
    document.getElementById("dashboard-user").classList.add("hidden");
    document.getElementById("dashboard-manager").classList.add("hidden");

    if (currentUser.role === "CITY_ADMIN") {
        document.getElementById("dashboard-manager").classList.remove("hidden");
        initManagerDashboard();
    } else {
        document.getElementById("dashboard-user").classList.remove("hidden");
        initUserDashboard();
    }
}

// ==================== USER DASHBOARD ====================
function initUserDashboard() {
    if (!userMap) {
        userMap = L.map("user-map").setView([13.0827, 80.2707], 13);
        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(userMap);
        L.marker([13.0827, 80.2707]).addTo(userMap).bindPopup("Your Home");
        L.marker([13.09, 80.28]).addTo(userMap).bindPopup("Sensor #A12 • Online");
    }

    // Energy chart
    if (userEnergyChart) userEnergyChart.destroy();
    const ctx = document.getElementById("user-energy-chart");
    userEnergyChart = new Chart(ctx, {
        type: "line",
        data: {
            labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            datasets: [{
                label: "Energy (kWh)",
                data: [48, 52, 41, 63, 55, 49, 34],
                borderColor: "#00f576",
                tension: 0.4,
                fill: true,
                backgroundColor: "rgba(0, 245, 118, 0.1)"
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });

    // Appliances
    const appliancesEl = document.getElementById("user-appliances");
    appliancesEl.innerHTML = `
        <div class="appliance"><span>EV Charger</span><span class="status online">Scheduled</span></div>
        <div class="appliance"><span>AC Unit</span><span class="status online">Running</span></div>
        <div class="appliance"><span>Washing Machine</span><span class="status offline">Idle</span></div>
    `;
}

// ==================== MANAGER DASHBOARD ====================
function initManagerDashboard() {
    document.getElementById("area-name").innerText = "Chennai South";

    if (!managerMap) {
        managerMap = L.map("manager-map").setView([13.05, 80.25], 11);
        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(managerMap);

        // Sample sensors
        const sensors = [
            [13.05, 80.25], [13.08, 80.30], [13.01, 80.22], [13.12, 80.28],
            [13.03, 80.19], [13.09, 80.35]
        ];
        sensors.forEach((pos, i) => {
            L.circleMarker(pos, {
                radius: 7,
                color: i % 2 === 0 ? "#00f576" : "#ff3838",
                fillOpacity: 0.9
            }).addTo(managerMap).bindPopup(`Sensor #S${100 + i}<br>Status: ${i % 2 === 0 ? "Online" : "Offline"}`);
        });
    }

    // Area chart
    if (managerChart) managerChart.destroy();
    const ctx = document.getElementById("manager-chart");
    managerChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            datasets: [
                { label: "Carbon (kg)", data: [1240, 980, 1320, 1150, 890, 1420, 780], backgroundColor: "#ff3838" },
                { label: "Energy (MWh)", data: [42, 38, 51, 47, 35, 55, 29], backgroundColor: "#00f576" }
            ]
        },
        options: { responsive: true, maintainAspectRatio: false }
    });

    renderHouses();
}

function renderHouses() {
    const container = document.getElementById("house-grid");
    container.innerHTML = "";

    const houses = [
        { id: 1, name: "House #42", energy: 38, carbon: 12.4, status: "online", alert: false },
        { id: 2, name: "House #87", energy: 51, carbon: 19.8, status: "online", alert: true },
        { id: 3, name: "House #15", energy: 29, carbon: 8.1, status: "offline", alert: false },
        { id: 4, name: "House #103", energy: 44, carbon: 14.2, status: "online", alert: false },
    ];

    houses.forEach(h => {
        const div = document.createElement("div");
        div.className = `house-card ${h.alert ? "alert" : ""}`;
        div.innerHTML = `
            <div class="house-header">
                <strong>${h.name}</strong>
                <span class="status-dot ${h.status}"></span>
            </div>
            <div class="house-stats">
                <div><i class="fas fa-bolt"></i> ${h.energy} kWh</div>
                <div><i class="fas fa-cloud"></i> ${h.carbon} kg</div>
            </div>
            <div class="house-footer">
                <span class="mini-badge">${h.status}</span>
                ${h.alert ? `<span class="mini-badge warning">Alert</span>` : ""}
            </div>
        `;
        container.appendChild(div);
    });
}

function refreshHouses() {
    renderHouses();
}

// ==================== PROFILE ====================
function showProfile() {
    alert(`Logged in as: ${currentUser.email}\nRole: ${currentUser.role}`);
}

// ==================== INIT ====================
document.addEventListener("DOMContentLoaded", () => {
    // Demo accounts prefill already done in HTML

    // Auto-login for testing if token exists (demo)
    const savedToken = localStorage.getItem("token");
    if (savedToken) {
        // For demo we assume token is valid
        currentUser = { email: "user@carbonwise.com", role: "CONSUMER", name: "Alex Rivera" };
        document.getElementById("auth-screen").classList.add("hidden");
        document.getElementById("app").classList.remove("hidden");
        document.getElementById("user-name").innerText = currentUser.name;
        document.getElementById("user-role").innerText = "User";
        document.getElementById("greeting-name").innerText = currentUser.name;
        setupNavigation();
        showDashboard();
    }
});