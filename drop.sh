#!/bin/bash

# Define Colors for GUI
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directory for databases
DATABASES_DIR="./databases"

# Ensure databases directory exists
mkdir -p "$DATABASES_DIR"

# Function to print messages in color
function print_message {
    case $1 in
        success)
            echo -e "${GREEN}$2${NC}"
            ;;
        error)
            echo -e "${RED}$2${NC}"
            ;;
        warning)
            echo -e "${YELLOW}$2${NC}"
            ;;
        info)
            echo -e "${BLUE}$2${NC}"
            ;;
        *)
            echo "$2"
            ;;
    esac
}

# Validate name according to Linux directory naming convention
function validate_name {
    if [[ "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to drop a database (directory) or a table (file)
function drop {
    case $1 in
        database)
            read -p "Enter the database name to drop: " db_name
            if validate_name "$db_name"; then
                if [ -d "$DATABASES_DIR/$db_name" ]; then
                    rm -r "$DATABASES_DIR/$db_name"
                    print_message success "Database '$db_name' dropped successfully!"
                else
                    print_message error "Database '$db_name' does not exist!"
                fi
            else
                print_message error "Invalid database name. Only alphanumeric characters, hyphens, and underscores are allowed."
            fi
            ;;
        table)
            read -p "Enter the database name that contains the table: " db_name
            if [ ! -d "$DATABASES_DIR/$db_name" ]; then
                print_message error "Database '$db_name' does not exist!"
                return
            fi

            read -p "Enter the table name to drop: " table_name
            if validate_name "$table_name"; then
                if [ -f "$DATABASES_DIR/$db_name/$table_name" ]; then
                    rm "$DATABASES_DIR/$db_name/$table_name"
                    print_message success "Table '$table_name' dropped successfully from database '$db_name'!"
                else
                    print_message error "Table '$table_name' does not exist in database '$db_name'!"
                fi
            else
                print_message error "Invalid table name. Only alphanumeric characters, hyphens, and underscores are allowed."
            fi
            ;;
        *)
            print_message warning "Usage: drop [database|table]"
            ;;
    esac
}

# Example usage
print_message info "Welcome to the Drop Management System"
print_message info "Please use the 'drop' function to remove a database or a table."
