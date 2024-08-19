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

# Function to create a database (directory) or a table (file)
function create {
    case $1 in
        database)
            read -p "Enter the database name: " db_name
            if validate_name "$db_name"; then
                if [ -d "$DATABASES_DIR/$db_name" ]; then
                    print_message error "Database '$db_name' already exists!"
                else
                    mkdir "$DATABASES_DIR/$db_name"
                    print_message success "Database '$db_name' created successfully!"
                fi
            else
                print_message error "Invalid database name. Only alphanumeric characters, hyphens, and underscores are allowed."
            fi
            ;;
        table)
            read -p "Enter the database name to add the table to: " db_name
            if [ ! -d "$DATABASES_DIR/$db_name" ]; then
                print_message error "Database '$db_name' does not exist!"
                return
            fi

            read -p "Enter the table name: " table_name
            if validate_name "$table_name"; then
                if [ -f "$DATABASES_DIR/$db_name/$table_name" ]; then
                    print_message error "Table '$table_name' already exists in database '$db_name'!"
                else
                    touch "$DATABASES_DIR/$db_name/$table_name"
                    print_message success "Table '$table_name' created successfully in database '$db_name'!"
                    create_columns "$DATABASES_DIR/$db_name/$table_name"
                fi
            else
                print_message error "Invalid table name. Only alphanumeric characters, hyphens, and underscores are allowed."
            fi
            ;;
        *)
            print_message warning "Usage: create [database|table]"
            ;;
    esac
}

# Function to create columns for a table
function create_columns {
    local table_file=$1
    echo "Define columns for the table. (Press ENTER after specifying each column, or type 'done' when finished.)"
    
    while true; do
        read -p "Enter column name: " column_name
        if [ "$column_name" == "done" ]; then
            break
        fi

        if validate_name "$column_name"; then
            read -p "Specify data type for column '$column_name' (numeric/character/date): " column_type
            case $column_type in
                numeric|character|date)
                    echo "$column_name:$column_type" >> "$table_file"
                    print_message success "Column '$column_name' with data type '$column_type' added!"
                    ;;
                *)
                    print_message error "Invalid data type. Please choose from numeric, character, or date."
                    ;;
            esac
        else
            print_message error "Invalid column name. Only alphanumeric characters, hyphens, and underscores are allowed."
        fi
    done

    print_message info "Table schema saved in '$table_file'."
}

# Example usage
print_message info "Welcome to the Database Management System"
print_message info "Please use the 'create' function to add a database or a table."
