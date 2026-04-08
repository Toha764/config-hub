# Plasma Ricing (KDE)

### A step-by-step guide:

- Kvantum (Qt styling)
- Layan theme
- Icon pack (YAI)
- Top bar tweaks (Colorizer)
- Panel spacing tweaks

1. Install Required Packages
   - Add Papirus repository (for icons & extras)
     `sudo add-apt-repository ppa:papirus/papirus`
     `sudo apt update`
   - Install Kvantum (Qt theme engine)
     `sudo apt install qt6-style-kvantum qt6-style-kvantum-themes`

2. Install Layan Theme
   Option A: Clone from GitHub
   `git clone https://github.com/vinceliuice/Layan-kde.git
cd Layan-kde
./install.sh`
   Option B: Manual install
   Download theme from GitHub
   Extract into:
   ` ~/.local/share/plasma/desktoptheme/`

3. Apply the Theme (KDE Settings)
   Open:
   System Settings → Appearance

Apply:
Global Theme → Layan
Plasma Style → Layan
Application Style (Qt) → Kvantum

4. ⚙️ Configure Kvantum
   Launch Kvantum Manager:
   kvantummanager
   Steps:
   Select Layan (or matching Kvantum theme)
   Click Use this theme

5. Install Icon Pack (YAI – Yet Another Icons)
   Install via Git
   `git clone https://github.com/vinceliuice/Yet-Another-Icon-Theme.git
 cd Yet-Another-Icon-Theme
./install.sh`
   Apply Icons
   System Settings → Appearance → Icons → Yet Another Icon Theme

6. Install & Configure Top Bar (Colorizer)
   Install Colorizer widget
   Right-click panel → Add Widgets
   Search: Colorizer
   Install from KDE Store
   Configure:
   Enable dynamic coloring
   Match accent color with wallpaper/theme

7. Panel / Top Bar Tweaks
   Right-click panel → Enter Edit Mode
   Adjust:
   Panel height → your preference (usually 32–40px)
   Spacing / margins
   Disable:
   Panel spacing on hover (if using override/page-space tweak)
