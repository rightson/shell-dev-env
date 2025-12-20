#!/bin/bash

# LM Studio Utility Script
# Provides convenient commands for managing LM Studio models

set -e

# Configuration
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/lm-studio"
CONFIG_FILE="$CONFIG_DIR/config.json"
DEFAULT_WAIT_INTERVAL=3

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure config directory exists
ensure_config_dir() {
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
    fi
}

# Initialize config file if it doesn't exist
init_config() {
    ensure_config_dir
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" << 'EOF'
{
  "default_model": null,
  "wait_interval": 3
}
EOF
    fi
}

# Read config value using simple JSON parsing
get_config() {
    local key="$1"
    init_config

    if [ -f "$CONFIG_FILE" ]; then
        # Use python for reliable JSON parsing if available, otherwise fallback to grep/sed
        if command -v python3 &> /dev/null; then
            python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('$key', ''))" 2>/dev/null || echo ""
        else
            grep "\"$key\"" "$CONFIG_FILE" | sed -E 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"?([^",}]+)"?.*/\1/' | tr -d ' ' | sed 's/null//'
        fi
    fi
}

# Set config value
set_config() {
    local key="$1"
    local value="$2"
    init_config

    if command -v python3 &> /dev/null; then
        # Use python for reliable JSON manipulation
        python3 << EOF
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)
config['$key'] = '$value'
with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2)
EOF
    else
        # Fallback to sed (less reliable but works without python)
        local temp_file="${CONFIG_FILE}.tmp"
        if grep -q "\"$key\"" "$CONFIG_FILE"; then
            sed -E "s/(\"$key\"[[:space:]]*:[[:space:]]*)[^,}]*/\1\"$value\"/" "$CONFIG_FILE" > "$temp_file"
            mv "$temp_file" "$CONFIG_FILE"
        fi
    fi
}

# Print usage information
usage() {
    local default_model=$(get_config "default_model")
    if [ -z "$default_model" ]; then
        default_model="(not set)"
    fi

    cat << EOF
Usage: $(basename "$0") [COMMAND] [OPTIONS]

LM Studio utility for managing models.

Commands:
    load [MODEL]           Load a model (waits if not available)
    list                   List all available models
    status [MODEL]         Check if a model is available
    set-default MODEL      Set default model for auto-loading
    get-default            Show current default model
    config                 Show current configuration
    help                   Show this help message

Options:
    -w, --wait SEC         Wait interval in seconds (default: from config or 3)
    -n, --no-wait          Don't wait, fail immediately if model not found
    -h, --help             Show this help message

Configuration:
    Config file: $CONFIG_FILE
    Default model: $default_model

Examples:
    $(basename "$0")                              # Show this help
    $(basename "$0") list                         # List all models
    $(basename "$0") set-default my-model         # Set default model
    $(basename "$0") load                         # Load default model
    $(basename "$0") load my-model                # Load specific model
    $(basename "$0") load my-model -w 5           # Load with 5s wait interval
    $(basename "$0") status my-model              # Check model status

EOF
}

# Print error message and exit
error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Print success message
success() {
    echo -e "${GREEN}$1${NC}"
}

# Print info message
info() {
    echo -e "${YELLOW}$1${NC}"
}

# Print blue message
highlight() {
    echo -e "${BLUE}$1${NC}"
}

# Check if model is available
check_model_available() {
    local model_name="$1"
    lms ls 2>/dev/null | grep -q "$model_name"
}

# List all available models
list_models() {
    echo "Available models:"
    lms ls
}

# Check model status
check_status() {
    local model_name="$1"

    if [ -z "$model_name" ]; then
        error "No model specified. Use: $(basename "$0") status MODEL"
    fi

    if check_model_available "$model_name"; then
        success "Model '$model_name' is available"
        return 0
    else
        info "Model '$model_name' is not available"
        return 1
    fi
}

# Set default model
set_default_model() {
    local model_name="$1"

    if [ -z "$model_name" ]; then
        error "No model specified. Use: $(basename "$0") set-default MODEL"
    fi

    set_config "default_model" "$model_name"
    success "Default model set to: $model_name"
    info "Run '$(basename "$0") load' to load this model"
}

# Get default model
get_default_model() {
    local default_model=$(get_config "default_model")

    if [ -z "$default_model" ]; then
        info "No default model configured"
        echo "Use '$(basename "$0") set-default MODEL' to set one"
    else
        highlight "Default model: $default_model"
    fi
}

# Show configuration
show_config() {
    highlight "LM Studio Configuration"
    echo "---"
    echo "Config file: $CONFIG_FILE"

    if [ -f "$CONFIG_FILE" ]; then
        echo ""
        cat "$CONFIG_FILE"
    else
        echo ""
        info "Config file not found (will be created on first use)"
    fi
}

# Load model with optional waiting
load_model() {
    local model_name="$1"
    local wait_interval="$2"
    local no_wait="$3"

    # If no model specified, try to get from config
    if [ -z "$model_name" ]; then
        model_name=$(get_config "default_model")
        if [ -z "$model_name" ]; then
            error "No model specified and no default model configured.\nUse: $(basename "$0") set-default MODEL"
        fi
        info "Using default model: $model_name"
    fi

    # Get wait interval from config if not specified
    if [ "$wait_interval" = "$DEFAULT_WAIT_INTERVAL" ]; then
        local config_wait=$(get_config "wait_interval")
        if [ -n "$config_wait" ]; then
            wait_interval="$config_wait"
        fi
    fi

    # Check if model is already available
    if check_model_available "$model_name"; then
        success "Model '$model_name' found! Loading..."
        lms load "$model_name"
        return 0
    fi

    # If no-wait flag is set, fail immediately
    if [ "$no_wait" = true ]; then
        error "Model '$model_name' not found and --no-wait flag is set"
    fi

    # Wait for model to become available
    info "Waiting for model '$model_name' to be available..."

    while true; do
        if check_model_available "$model_name"; then
            success "Model '$model_name' found! Loading..."
            lms load "$model_name"
            break
        else
            echo "Model not found yet, checking again in $wait_interval seconds..."
            sleep "$wait_interval"
        fi
    done
}

# Main script logic
main() {
    local command=""
    local model_name=""
    local wait_interval="$DEFAULT_WAIT_INTERVAL"
    local no_wait=false

    # If no arguments, show usage
    if [ $# -eq 0 ]; then
        usage
        exit 0
    fi

    # Parse command if provided
    if [ $# -gt 0 ] && [[ ! "$1" =~ ^- ]]; then
        command="$1"
        shift
    fi

    # For commands that take a model as positional argument
    if [ $# -gt 0 ] && [[ ! "$1" =~ ^- ]]; then
        case "$command" in
            load|status|set-default)
                model_name="$1"
                shift
                ;;
        esac
    fi

    # Parse options
    while [ $# -gt 0 ]; do
        case "$1" in
            -w|--wait)
                wait_interval="$2"
                shift 2
                ;;
            -n|--no-wait)
                no_wait=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                error "Unknown option: $1\nUse --help for usage information"
                ;;
        esac
    done

    # Execute command
    case "$command" in
        load)
            load_model "$model_name" "$wait_interval" "$no_wait"
            ;;
        list|ls)
            list_models
            ;;
        status)
            check_status "$model_name"
            ;;
        set-default)
            set_default_model "$model_name"
            ;;
        get-default)
            get_default_model
            ;;
        config)
            show_config
            ;;
        help|"")
            usage
            exit 0
            ;;
        *)
            error "Unknown command: $command\nUse --help for usage information"
            ;;
    esac
}

main "$@"
