#!/bin/bash

# Test script to verify the category browser functionality

# Set the environment
export PROMPTS_DIR="Prompts/EN"

# Source the search functions
source scripts/search_prompts.sh

# Test the category browser
echo "Testing Category Browser..."
echo "Selecting category 'general' (option 4)..."

# Test browse_category_prompts directly
browse_category_prompts "general"