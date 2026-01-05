#!/bin/bash

# AnythingLLM Agent Setup - Automated Installation Script
# This script automates the setup of AnythingLLM with agent blueprints

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup
main() {
    print_header "AnythingLLM Agent Setup"
    
    echo "This script will:"
    echo "  1. Check system requirements"
    echo "  2. Install Docker (if needed)"
    echo "  3. Pull and run AnythingLLM"
    echo "  4. Clone agent blueprints repository"
    echo "  5. Configure initial settings"
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    
    # Step 1: Check requirements
    print_header "Step 1: Checking Requirements"
    check_requirements
    
    # Step 2: Install Docker if needed
    if ! command_exists docker; then
        print_header "Step 2: Installing Docker"
        install_docker
    else
        print_success "Docker already installed"
    fi
    
    # Step 3: Setup AnythingLLM
    print_header "Step 3: Setting up AnythingLLM"
    setup_anythingllm
    
    # Step 4: Clone agent blueprints
    print_header "Step 4: Cloning Agent Blueprints"
    clone_blueprints
    
    # Step 5: Configuration
    print_header "Step 5: Configuration"
    configure_setup
    
    # Finish
    print_header "Setup Complete!"
    show_next_steps
}

check_requirements() {
    local missing_reqs=0
    
    # Check OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_success "Operating System: Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_success "Operating System: macOS"
    else
        print_warning "Operating System: $OSTYPE (untested)"
    fi
    
    # Check disk space (need at least 5GB)
    available_space=$(df -h . | awk 'NR==2 {print $4}' | sed 's/G//')
    if (( $(echo "$available_space > 5" | bc -l) )); then
        print_success "Disk space: ${available_space}GB available"
    else
        print_warning "Low disk space: ${available_space}GB (recommend 5GB+)"
    fi
    
    # Check for curl or wget
    if command_exists curl; then
        print_success "curl is installed"
    elif command_exists wget; then
        print_success "wget is installed"
    else
        print_error "Neither curl nor wget found. Please install one."
        missing_reqs=1
    fi
    
    # Check for git
    if command_exists git; then
        print_success "git is installed"
    else
        print_error "git not found. Please install git."
        missing_reqs=1
    fi
    
    if [ $missing_reqs -eq 1 ]; then
        print_error "Missing required dependencies. Please install them and try again."
        exit 1
    fi
}

install_docker() {
    print_info "Installing Docker..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux installation
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
        
        # Add current user to docker group
        sudo usermod -aG docker $USER
        print_success "Docker installed"
        print_warning "You may need to log out and back in for group changes to take effect"
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        print_info "Please install Docker Desktop from:"
        print_info "https://www.docker.com/products/docker-desktop"
        print_warning "After installation, run this script again."
        exit 0
    fi
}

setup_anythingllm() {
    # Create storage directory
    print_info "Creating storage directory..."
    mkdir -p ./anythingllm-storage
    print_success "Storage directory created"
    
    # Pull Docker image
    print_info "Pulling AnythingLLM Docker image (this may take a few minutes)..."
    if docker pull mintplexlabs/anythingllm; then
        print_success "Docker image pulled"
    else
        print_error "Failed to pull Docker image"
        exit 1
    fi
    
    # Check if container already exists
    if docker ps -a | grep -q anythingllm; then
        print_warning "AnythingLLM container already exists"
        read -p "Remove existing container? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker stop anythingllm 2>/dev/null || true
            docker rm anythingllm
            print_success "Removed existing container"
        else
            print_info "Keeping existing container"
            return
        fi
    fi
    
    # Run container
    print_info "Starting AnythingLLM container..."
    docker run -d \
        -p 3001:3001 \
        --name anythingllm \
        -v ${PWD}/anythingllm-storage:/app/server/storage \
        -e STORAGE_DIR="/app/server/storage" \
        --restart unless-stopped \
        mintplexlabs/anythingllm
    
    if [ $? -eq 0 ]; then
        print_success "AnythingLLM container started"
        print_info "Waiting for AnythingLLM to be ready..."
        sleep 10
        
        # Check if accessible
        if curl -s http://localhost:3001 > /dev/null; then
            print_success "AnythingLLM is accessible at http://localhost:3001"
        else
            print_warning "AnythingLLM may still be starting up"
        fi
    else
        print_error "Failed to start container"
        exit 1
    fi
}

clone_blueprints() {
    # Ask for clone directory
    read -p "Where should we clone the agent blueprints? [./ai-agent-blueprints]: " blueprints_dir
    blueprints_dir=${blueprints_dir:-./ai-agent-blueprints}
    
    if [ -d "$blueprints_dir" ]; then
        print_warning "Directory $blueprints_dir already exists"
        read -p "Update existing repository? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cd "$blueprints_dir"
            git pull
            cd - > /dev/null
            print_success "Repository updated"
        fi
    else
        print_info "Cloning agent blueprints repository..."
        if git clone https://github.com/kasjens/ai-agent-blueprints.git "$blueprints_dir"; then
            print_success "Agent blueprints cloned to $blueprints_dir"
        else
            print_error "Failed to clone repository"
            exit 1
        fi
    fi
    
    # Save path to config
    echo "BLUEPRINTS_PATH=$blueprints_dir" > .setup-config
}

configure_setup() {
    print_info "Configuration options:"
    echo ""
    
    # Ask for Mistral API key
    read -p "Do you want to configure Mistral API now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your Mistral API key: " mistral_key
        if [ ! -z "$mistral_key" ]; then
            echo "MISTRAL_API_KEY=$mistral_key" >> .setup-config
            print_success "Mistral API key saved to .setup-config"
            print_warning "Keep this file secure and don't commit it to git!"
        fi
    fi
    
    # Create .gitignore if it doesn't exist
    if [ ! -f .gitignore ]; then
        echo ".setup-config" > .gitignore
        echo "anythingllm-storage/" >> .gitignore
        echo ".env" >> .gitignore
        print_success "Created .gitignore"
    fi
}

show_next_steps() {
    echo ""
    echo "================================"
    echo "🎉 Setup Complete!"
    echo "================================"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Open AnythingLLM:"
    echo "   ${GREEN}http://localhost:3001${NC}"
    echo ""
    echo "2. Complete the onboarding wizard"
    echo ""
    echo "3. Configure Mistral API:"
    echo "   - Go to Settings → LLM Preference"
    echo "   - Provider: OpenAI"
    echo "   - Base URL: https://api.mistral.ai/v1"
    echo "   - API Key: [your-mistral-api-key]"
    echo "   - Model: mistral-large-latest"
    echo ""
    echo "4. Import an agent blueprint:"
    echo "   - Open: $(cat .setup-config | grep BLUEPRINTS_PATH | cut -d'=' -f2)/agents/core/default-agent.md"
    echo "   - Copy the System Prompt section"
    echo "   - Paste into Workspace Settings"
    echo ""
    echo "5. Read the documentation:"
    echo "   - Quick Start: ${BLUE}./guides/quick-start.md${NC}"
    echo "   - Agent Integration: ${BLUE}./docs/agent-integration.md${NC}"
    echo "   - Example Workflows: ${BLUE}./examples/workflows/${NC}"
    echo ""
    echo "Useful commands:"
    echo "  ${BLUE}docker logs anythingllm${NC}         - View logs"
    echo "  ${BLUE}docker stop anythingllm${NC}         - Stop container"
    echo "  ${BLUE}docker start anythingllm${NC}        - Start container"
    echo "  ${BLUE}docker restart anythingllm${NC}      - Restart container"
    echo ""
    echo "For help, see: ${BLUE}./README.md${NC}"
    echo ""
}

# Run main function
main
