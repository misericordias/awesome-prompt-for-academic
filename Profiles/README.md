# User Profile Configuration

This directory contains user profile configuration files for the Awesome Academic Prompts Toolkit.

## Files

- `default_profile.conf` - Default configuration template (DO NOT EDIT)
- `user_profile.conf` - Your personal configuration (safe to edit)

## Configuration Options

### Display Settings
- `SHOW_WELCOME` - Show welcome message on startup (true/false)
- `SHOW_COLORS` - Enable colored output (true/false)
- `AUTO_SAVE` - Auto-save settings (true/false)

### Interface Settings
- `DEFAULT_LANGUAGE` - Default language for prompts (EN, ZH, JP, DE, FR, ES, IT, PT, RU, AR, KO, HI)
- `DEFAULT_CATEGORY` - Default category to start with
- `INTERFACE_STYLE` - Interface style (modern, classic, minimal)

### Search Settings
- `SEARCH_HISTORY_SIZE` - Number of search queries to remember (1-50)
- `DEFAULT_SEARCH_MODE` - Default search mode (interactive, quick, category)

### Tool Settings
- `PROMPT_VALIDATION_STRICT` - Strict validation for new prompts (true/false)
- `AUTO_TRANSLATE` - Auto-translate prompts to other languages (true/false)
- `BACKUP_BEFORE_EDIT` - Create backup before editing files (true/false)

## How to Use

### Via Main Menu
1. Run `./main.sh`
2. Select option 7 (⚙️ Settings)
3. Choose from the available options:
   - View Current Profile
   - Edit Settings
   - Reset to Defaults
   - Open Profile File

### Manual Editing
You can directly edit `user_profile.conf` with any text editor:
```bash
nano Profiles/user_profile.conf
# or
vim Profiles/user_profile.conf
# or
code Profiles/user_profile.conf
```

### Example Configuration
```bash
# Display Settings
SHOW_WELCOME=false         # Disable welcome message
SHOW_COLORS=true          # Keep colored output
AUTO_SAVE=true           # Auto-save changes

# Interface Settings
DEFAULT_LANGUAGE=ZH       # Use Chinese as default
DEFAULT_CATEGORY=computer-science
INTERFACE_STYLE=modern

# Search Settings
SEARCH_HISTORY_SIZE=20    # Remember 20 search queries
DEFAULT_SEARCH_MODE=quick # Start with quick search

# Tool Settings
PROMPT_VALIDATION_STRICT=false  # Relaxed validation
AUTO_TRANSLATE=true      # Enable auto-translation
BACKUP_BEFORE_EDIT=true  # Always create backups
```

## Tips

- **Backup**: Always backup your profile before making major changes
- **Validation**: The toolkit validates your settings and provides helpful error messages
- **Defaults**: You can always reset to defaults if something goes wrong
- **Auto-save**: With `AUTO_SAVE=true`, your changes are saved immediately
- **Language Support**: All 12 supported languages can be set as default

## Troubleshooting

### Profile Not Found
If you get "Profile not found" errors:
1. Run the main script - it will create a default profile automatically
2. Or manually copy `default_profile.conf` to `user_profile.conf`

### Invalid Settings
If you have invalid settings:
1. Use the "Reset to Defaults" option in the Settings menu
2. Or manually edit the file and fix syntax errors

### Permission Issues
If you can't save changes:
1. Check file permissions: `ls -la Profiles/`
2. Make sure the directory is writable: `chmod 755 Profiles/`

## Advanced Usage

### Custom Scripts
You can create custom scripts that read profile values:
```bash
#!/bin/bash
source main.sh  # Load profile functions
SHOW_WELCOME=$(read_profile_value "SHOW_WELCOME" "true")
echo "Welcome setting: $SHOW_WELCOME"
```

### Profile Synchronization
To sync profiles across multiple machines:
1. Use version control (git) for the Profiles directory
2. Or use cloud storage services
3. Remember to backup before syncing

## Support

If you encounter issues with profile configuration:
1. Check the main script's help: `./main.sh --help`
2. Use the Settings menu to reset to defaults
3. Check file syntax and permissions
4. Refer to the main README.md for general troubleshooting
