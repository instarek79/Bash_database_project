#!/bin/bash
source ./create.sh 
source ./drop.sh
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
function intro {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${GREEN}     WELCOME TO DATABASE MANAGEMENT SYSTEM${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${YELLOW}1. Create Database${NC}"
    echo -e "${YELLOW}2. Create Table${NC}"
    echo -e "${YELLOW}3. Drop Database${NC}"
    echo -e "${YELLOW}4. Drop Table${NC}"
    echo -e "${BLUE}==========================================${NC}"
}
# Main Menu Function
function menu {
    intro
    read -p "Please choose an option (1-4): " choice

    case $choice in
        1)
            echo -e "${BLUE}You selected: Create Database${NC}"
            create database
            ;;
        2)
            echo -e "${BLUE}You selected: Create Table${NC}"
            create table
            ;;
        3)
            echo -e "${BLUE}You selected: Drop Database${NC}"
            drop database
            ;;
        4)
            echo -e "${BLUE}You selected: Drop Table${NC}"
            drop table
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac
}
# Main Program Loop
while true; do
    menu
    read -p "Do you want to perform another operation? (y/n): " repeat
    if [[ "$repeat" != "y" ]]; then
        echo -e "${GREEN}Goodbye!${NC}"
        break
    fi
done
