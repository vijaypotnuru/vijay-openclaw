# Mission Control Designs

Modern dark-mode cyberpunk designs for the OpenClaw Mission Control application.

## Design System

### Color Palette
- **Background**: `#121416` (Deep charcoal)
- **Surface**: `#1e2022` (Card backgrounds)
- **Surface High**: `#282a2c` (Elevated cards)
- **Surface Highest**: `#333537` (Borders, dividers)
- **Primary (Cyan)**: `#00f0ff` (Accents, active states, neon glow)
- **Secondary (Amber)**: `#ffba20` (Warnings, highlights)
- **Tertiary (Rose)**: `#ffcec9` (Errors, alerts)
- **On Surface**: `#e2e2e5` (Primary text)
- **On Surface Variant**: `#b9cacb` (Secondary text)

### Typography
- **Font**: Space Grotesk (Google Fonts)
- **Headline XL**: 40px, weight 700, letter-spacing -0.02em
- **Headline LG**: 24px, weight 600, letter-spacing 0.05em
- **Body MD**: 16px, weight 400, letter-spacing 0.01em
- **Label Caps**: 12px, weight 700, letter-spacing 0.15em
- **Mono Data**: 14px-18px, weight 400-500, monospace

### Effects
- Neon glow: `box-shadow: 0 0 10px #00f0ff, 0 0 20px rgba(0, 240, 255, 0.3)`
- Scanline overlay: CSS gradient pattern
- Glitch hover: Text shadow with cyan/magenta offset
- Card hover: Border color transition to primary

## Pages

### 1. index.html - Dashboard
Main overview with stat cards and agent grid.
- Total Agents: 184
- Active Tasks: Live
- Completed: Live
- Autopilots: Live

### 2. campaigns.html - Campaigns
Email outreach and follow-up sequences management.

### 3. employees.html - Employees
Employee management with status tracking.

### 4. tasks.html - Tasks
Task management and scheduling.

### 5. autopilots.html - Autopilots
Automated workflow management.

### 6. browser.html - Browser
Web browser automation interface.

### 7. settings.html - Settings
System configuration and preferences.

### 8. active.html - Active Sessions
Live monitoring of active sessions.

### 9. logs.html - Logs
System logs and activity tracking.

### 10. launch.html - Launch
Deployment and launch management.

## Usage
Each HTML file is a standalone design prototype. Open in any browser to view.
