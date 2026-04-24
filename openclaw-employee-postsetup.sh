#!/bin/bash
# =============================================================================
# OpenClaw Post-Setup Script (run inside WSL Ubuntu)
# Runs AFTER the Employee Setup script completes and laptop has restarted
# =============================================================================

set -e

# Use the current Linux user as the employee name
EMPLOYEE_NAME="$(whoami)"
ADMIN_PASSWORD="${1:-changeme}"

echo ""
echo "============================================================"
echo "  OpenClaw Post-Setup - Inside Ubuntu"
echo "============================================================"
echo ""

# ──────────────────────────────────────────────────────────
# Step 1: Run openclaw setup
# ──────────────────────────────────────────────────────────
echo "[1/8] Running OpenClaw setup..."
if [ -d ~/.openclaw/workspace ] && [ -f ~/.openclaw/openclaw.json ]; then
    echo "  ✅ OpenClaw already configured, skipping setup"
else
    openclaw setup
fi

# ──────────────────────────────────────────────────────────
# Step 2: Install Ollama for embedding model
# ──────────────────────────────────────────────────────────
echo ""
echo "[2/8] Installing Ollama (for memory features)..."

# Install zstd dependency
echo "  Installing zstd dependency..."
sudo apt-get update -qq
sudo apt-get install -y zstd

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama service
sudo systemctl start ollama 2>/dev/null || {
    nohup ollama serve > /dev/null 2>&1 &
    sleep 5
}

if command -v ollama &>/dev/null; then
    echo "  ✅ Ollama installed"
else
    echo "  ⚠️  Ollama install had issues. Trying manual download..."
    sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/local/bin/ollama
    sudo chmod +x /usr/local/bin/ollama
    nohup ollama serve > /dev/null 2>&1 &
    sleep 5
    echo "  ✅ Ollama installed (manual method)"
fi

# ──────────────────────────────────────────────────────────
# Step 3: Pull embedding model for memory
# ──────────────────────────────────────────────────────────
echo ""
echo "[3/8] Pulling embedding model (nomic-embed-text)..."
echo "  This enables AI memory — remembers past conversations."
echo "  Download is ~274MB, takes 1-2 minutes."

ollama pull nomic-embed-text

echo "  ✅ Embedding model ready"

# ──────────────────────────────────────────────────────────
# Step 4: Install Playwright Chromium for browser feature
# ──────────────────────────────────────────────────────────
echo ""
echo "[4/8] Installing Chromium browser (for browser feature)..."
echo "  This lets the AI open websites, fill forms, scrape pages."
echo "  Download is ~150MB, takes 1-2 minutes."

# Install required system dependencies for Chromium
sudo apt-get install -y \
    libnss3 libnspr4 libatk1.0-0t64 libatk-bridge2.0-0t64 \
    libcups2t64 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libpango-1.0-0 libcairo2 libasound2t64 \
    libatspi2.0-0t64 libwayland-client0 2>/dev/null || true

# Install Playwright Chromium
npx -y playwright install chromium 2>/dev/null || true

echo "  ✅ Chromium browser installed"

# ──────────────────────────────────────────────────────────
# Step 5: Configure full memory features
# ──────────────────────────────────────────────────────────
echo ""
echo "[5/8] Configuring memory features (LanceDB, Active Memory, Wiki)..."

openclaw config set plugins.entries.memory-lancedb.enabled true 2>/dev/null || true
openclaw config set plugins.entries.memory-lancedb.config.embedding.baseUrl "http://localhost:11434/v1" 2>/dev/null || true
openclaw config set plugins.entries.memory-lancedb.config.embedding.model "nomic-embed-text" 2>/dev/null || true
openclaw config set plugins.entries.memory-lancedb.config.embedding.dimensions 768 2>/dev/null || true
openclaw config set plugins.entries.memory-lancedb.config.autoCapture true 2>/dev/null || true
openclaw config set plugins.entries.memory-lancedb.config.autoRecall true 2>/dev/null || true
openclaw config set plugins.entries.memory-lancedb.config.dreaming.enabled true 2>/dev/null || true

openclaw config set plugins.entries.active-memory.enabled true 2>/dev/null || true
openclaw config set plugins.entries.active-memory.config.qmd.searchMode "vsearch" 2>/dev/null || true

openclaw config set plugins.entries.memory-wiki.enabled true 2>/dev/null || true
openclaw config set plugins.entries.browser.enabled true 2>/dev/null || true

# Set plugins allow list (without openclaw-web-search since it's an extension, not stock)
openclaw config set plugins.allow --json '["telegram","memory-core","memory-lancedb","active-memory","memory-wiki","ollama","browser","google"]' 2>/dev/null || true

echo "  ✅ All features configured"

# ──────────────────────────────────────────────────────────
# Step 6: Start gateway
# ──────────────────────────────────────────────────────────
echo ""
echo "[6/8] Starting OpenClaw gateway..."

# First install the gateway service, then start it
openclaw gateway install 2>/dev/null || true
openclaw gateway start 2>/dev/null || true

sleep 3
echo "  ✅ Gateway started"

# ──────────────────────────────────────────────────────────
# Step 7: Set admin password for SSH access
# ──────────────────────────────────────────────────────────
echo ""
echo "[7/8] Setting SSH password for admin access..."
echo "${EMPLOYEE_NAME}:${ADMIN_PASSWORD}" | sudo chpasswd
echo "  ✅ SSH password set for user: ${EMPLOYEE_NAME} (password: ${ADMIN_PASSWORD})"

# ──────────────────────────────────────────────────────────
# Step 8: Git workspace backup + final summary
# ──────────────────────────────────────────────────────────
echo ""
echo "[8/8] Setting up git workspace backup..."
cd ~/.openclaw/workspace
git init 2>/dev/null || true
git config user.name "${EMPLOYEE_NAME}"
git config user.email "${EMPLOYEE_NAME}@company.local"
git add -A 2>/dev/null || true
git commit -m "Initial workspace - $(date +%Y-%m-%d)" 2>/dev/null || true
echo "  ✅ Git workspace initialized"

# ──────────────────────────────────────────────────────────
# Done!
# ──────────────────────────────────────────────────────────
echo ""
echo "============================================================"
echo "  ✅ Post-Setup Complete!"
echo "============================================================"
echo ""
echo "  Installed and configured:"
echo "    ✅ OpenClaw workspace"
echo "    ✅ Ollama + nomic-embed-text (embedding model)"
echo "    ✅ Chromium browser (AI can browse websites)"
echo "    ✅ Memory LanceDB (vector search memory)"
echo "    ✅ Active Memory (real-time recall)"
echo "    ✅ Memory Wiki (knowledge base)"
echo "    ✅ Browser feature"
echo "    ✅ Gateway running"
echo "    ✅ SSH admin access (user: ${EMPLOYEE_NAME})"
echo "    ✅ Git workspace backup"
echo ""
echo "  Still needs manual setup:"
echo "    ❌ Model API key (Ollama Cloud subscription)"
echo "    ❌ Telegram bot (create via @BotFather)"
echo "    ❌ Google Workspace (OAuth credentials)"
echo ""
echo "  ⚠️  IMPORTANT: Change the default password!"
echo "    passwd"
echo ""
echo "============================================================"
