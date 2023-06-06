#!/bin/bash

# List of extensions to install
echo "Downloading and Installing all VSCode Extensions"

extensions=(
    alefragnani.project-manager
	alexdima.copy-relative-path
	AncientLord.nightowl-theme
	bmewburn.vscode-intelephense-client
	bradgashler.htmltagwrap
	christian-kohler.path-intellisense
	claudiosanches.woocommerce
	claudiosanches.wpcs-whitelist-flags
	dbaeumer.vscode-eslint
	dsznajder.es7-react-js-snippets
	eamodio.gitlens
	EditorConfig.EditorConfig
	esbenp.prettier-vscode
	ExodiusStudios.comment-anchors
	fayras.simple-new-file
	formulahendry.auto-close-tag
	formulahendry.auto-rename-tag
	GitHub.github-vscode-theme
	GitHub.vscode-pull-request-github
	GrapeCity.gc-excelviewer
	humao.rest-client
	johnbillion.vscode-wordpress-hooks
	johnpapa.vscode-peacock
	kakumei.php-xdebug
	MehediDracula.php-namespace-resolver
	mitchdenny.ecdc
	mrmlnc.vscode-duplicate
	ms-vsliveshare.vsliveshare
	ms-vsliveshare.vsliveshare-audio
	ms-vsliveshare.vsliveshare-pack
	neilbrayfield.php-docblocker
	PKief.material-icon-theme
	pnp.polacode
	ritwickdey.LiveServer
	ryannaddy.laravel-artisan
	sadesyllas.vscode-workspace-switcher
	sdras.night-owl
	thenikso.github-plus-theme
	TomasHubelbauer.vscode-markdown-table-format
	Tyriar.lorem-ipsum
	usernamehw.errorlens
	valeryanm.vscode-phpsab
	wk-j.save-and-run
	wongjn.php-sniffer
	wordpresstoolbox.wordpress-toolbox
	xdebug.php-debug
	yassh.copy-with-line-numbers
	yogensia.searchwpdocs
	zhuangtongfa.material-theme
)

# Install each extension
for extension in "${extensions[@]}"; do
    code --install-extension "$extension"
done

echo "VSCode Extensions installation completed."

# Download composer.json file
echo "Downloading composer.json..."
curl -sSL -o "composer.json" https://raw.githubusercontent.com/lekhnath005/workspace-setup/master/composer.json

# Install composer dependencies
echo "Installing composer dependencies..."
composer install

echo "Composer installation completed."

# Download phpcs.xml file
echo "Downloading phpcs.xml..."
curl -sSL -o "phpcs.xml" https://raw.githubusercontent.com/lekhnath005/workspace-setup/master/phpcs.xml

echo "PHPCS rules downloading completed."

# Create the workspace file
echo "Workspace creation Initialized."

# Specify the Project name to save workspace path.
project_name=""
while [ -z "$project_name" ]; do
    read -p "Enter the current project name : " project_name
done

# Specify the file path to save the workspace.code-workspace file
read -p "Enter the file path to save the workspace.code-workspace file (default: C:/): " filepath
filepath="${filepath:-C:/}"  # Set the default value to current directory/workspace.code-workspace if no input is provided

# Convert the filepath to Windows path format
win_filepath=$(cygpath -w "$filepath")

# Create the workspace directory if it doesn't exist
mkdir -p "$win_filepath"

# Get the current directory
current_path="$(pwd)"

# Move two folders back
parent_path="$(dirname "$(dirname "$current_path")")"

# Convert path to Windows format
project_path=$(cygpath -w "$parent_path")
project_path=${project_path//\\//}

# Change directory to the workspace path
cd "$win_filepath" || exit

# Assign the string to the plugins variable
plugins="\${workspaceFolder:$project_name}/wp-content/plugins"
workspace="\${workspaceFolder:$project_name}"

# Create the workspace file with the specified name
cat > "$project_name.code-workspace" <<EOL
{
	"folders": [
		{
			"name": "${project_name}",
			"path": "${project_path}"
		}
	],
	"transient": false,
	"settings": {
		"phpsab.composerJsonPath": "wp-content/plugins/composer.json",
		"terminal.integrated.cwd": "$plugins",
		"files.exclude": {
			"**/wordpress/src": true,
			"**/wp-admin/images": true,
			"**/wp-admin/maint": true,
			"**/wp-admin/user": true,
			"**/wp-content/themes": true,
			"**/wp-content/upgrade": true,
			"**/wp-content/uploads": true,
			"**/wp-content/languages": true,
			"**/wp-content/mu-plugins": true,
			"**/wp-includes/certificates": true,
			"**/wp-includes/fonts": true,
			"**/wp-includes/ID3": true,
			"**/wp-includes/images": true,
			"**/wp-includes/IXR": true,
			"**/wp-includes/pomo": true,
			"**/wp-includes/random_compat": true,
			"**/wp-includes/theme-compat": true,
			"**/wp-includes/SimplePie": true,
			"**/local-phpinfo.php": true,
			"**/wp-activate.php": true,
			"**/wp-blog-header.php": true,
			"**/wp-comments-post.php": true,
			"**/wp-config-sample.php": true,
			"**/wp-tests-config-sample.php": true,
			"**/wp-cron.php": true,
			"**/wp-links-opml.php": true,
			"**/wp-load.php": true,
			"**/wp-login.php": true,
			"**/wp-mail.php": true,
			"**/wp-settings.php": true,
			"**/wp-signup.php": true,
			"**/wp-trackback.php": true,
			"**/xmlrpc.php": true,
			// WP Plugins Ignorance.
			"**/members": true,
			"**/wpforms": false,
			"**/wpforms-lite": true,
			"**/rtl-tester": true,
			"**/query-monitor": true,
			"**/user-switching": true,
			"**/loco-translate": true,
			"**/disable-json-api": true,
			"**/advanced-wp-reset": true,
			"**/display-environment-type": true,
		},
		"intelephense.diagnostics.undefinedConstants": false,
		"[php]": {
			"editor.formatOnSave": true
		},
		"cSpell.words": [
			"phpcs",
			"Twilio"
		],
	},
	"launch": {
		"version": "0.2.0",
		"configurations": [
			{
				"name": "Listen for Local Xdebug",
				"type": "php",
				"request": "launch",
				"port": 9000,
				"xdebugSettings": {
					"max_children": 128,
					"max_data": 1024,
					"max_depth": 3,
					"show_hidden": 1
				}
			},
			{
				"name": "Open the Edge DevTools",
				"type": "vscode-edge-devtools.debug",
				"request": "attach",
				"webRoot": "$workspace"
			},
			{
				"name": "Attach to Microsoft Edge",
				"type": "pwa-msedge",
				"request": "attach",
				"port": 9222,
				"webRoot": "$workspace"
			},
		],
		"compounds": [
			{
				"name": "Open the Edge DevTools and attach",
				"configurations": [
					"Open the Edge DevTools",
					"Attach to Microsoft Edge",
				]
			}
		]
	}
}
EOL

echo "Workspace path : $win_filepath"
echo "Workspace created successfully."

# Set the user's name and email
read -p "Enter your name: " name
read -p "Enter your email: " email

# Specify the directory to save the settings.json file
read -p "Enter the directory to save the settings.json file (default: C:/Users/Administrator/AppData/Roaming/Code/User): " directory
directory="${directory:-C:/Users/Administrator/AppData/Roaming/Code/User}"  # Set the default value to current directory if no input is provided

# Convert the filepath to Windows path format
win_filepath=$(cygpath -w "$directory")

# Check if settings.json already exists in the specified directory
if [ -f "$win_filepath/settings.json" ]; then
    read -p "settings.json already exists in $win_filepath. Do you want to replace it? (y/n): " replace_existing
    if [[ $replace_existing =~ ^[Yy]$ ]]; then
        rm "$win_filepath/settings.json"
    else
        echo "Operation cancelled."
        exit 0
    fi
fi

# Create the settings.json file
cat > "$directory/settings.json" <<EOF
{
	"editor.fontSize": 15,
	"editor.fontFamily": "'Cascadia Code', Consolas, 'Courier New', monospace",
	"editor.fontLigatures": "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'zero', 'onum'",
	"editor.linkedEditing": true,
	"editor.insertSpaces": false,
	"editor.suggest.preview": false,
	"editor.minimap.enabled": false,
	"editor.detectIndentation": false,
	"diffEditor.renderSideBySide": false,
	"editor.inlineSuggest.enabled": true,
	"editor.cursorSmoothCaretAnimation": true,
	"editor.bracketPairColorization.enabled": true,
	"editor.snippetSuggestions": "top",
	"editor.renderLineHighlight": "all",
	"editor.renderWhitespace": "trailing",
	"editor.guides.bracketPairs": "active",
	"editor.rulers": [
		50,
		70
	],
	"editor.formatOnSave": false,
	"editor.formatOnSaveMode": "file",
	"editor.defaultFormatter": "esbenp.prettier-vscode",
	"editor.codeActionsOnSave": {
		"source.fixAll.stylelint": false
	},
	"[php]": {
		"editor.formatOnSave": false,
		"editor.defaultFormatter": "valeryanm.vscode-phpsab"
	},
	"[yaml]": {
		"editor.formatOnSave": true,
		"editor.defaultFormatter": "redhat.vscode-yaml"
	},
	"[jsonc]": {
		"editor.defaultFormatter": "vscode.json-language-features"
	},
	"[markdown]": {
		"editor.formatOnSave": true,
	},
	"[javascript]": {
		"editor.formatOnSave": true,
		"editor.formatOnSaveMode": "modifications",
		"editor.defaultFormatter": "esbenp.prettier-vscode",
	},
	"[typescript]": {
		"editor.formatOnSave": true,
		"editor.formatOnSaveMode": "modifications",
	},
	"files.eol": "\n",
	"files.exclude": {
		"**/.idea": true,
		"**/.vscode": false,
		"**/.sass-cache": true,
		"**/.wordpress-org": true,
		"**/tmp": true,
		"**/build": true,
		"**/vendor": false,
		"**/db_data": true,
		"**/node_modules": true,
	},
	"files.associations": {
		"*.xml.dist": "xml",
		"*.yml.dist": "yaml",
		"*.jsx": "javascriptreact",
	},
	"files.trimFinalNewlines": true,
	"files.insertFinalNewline": true,
	"files.trimTrailingWhitespace": true,
	"window.autoDetectColorScheme": false,
	"window.customMenuBarAltFocus": false,
	"editor.tokenColorCustomizations": {
		"textMateRules": [
			{
				"scope": [
					"comment",
					"constant",
					"emphasis",
					"entity",
					"invalid",
					"keyword",
					"markup",
					"meta",
					"storage",
					"string",
					"strong",
					"support",
					"variable"
				],
				"settings": {
					"fontStyle": "italic"
				}
			}
		]
	},
	// Workbence.
	"workbench.tips.enabled": false,
	"workbench.startupEditor": "none",
	"workbench.sideBar.location": "right",
	"workbench.editor.splitSizing": "split",
	"workbench.editor.pinnedTabSizing": "shrink",
	"workbench.colorTheme": "GitHub Dark Dimmed",
	"workbench.iconTheme": "material-icon-theme",
	"workbench.preferredDarkColorTheme": "GitHub Dark Dimmed",
	"workbench.preferredLightColorTheme": "GitHub Light Default",
	// Features.
	"explorer.confirmDelete": false,
	"explorer.openEditors.visible": 0,
	"explorer.confirmDragAndDrop": false,
	"extensions.ignoreRecommendations": true,
	"extensions.supportUntrustedWorkspaces": {
		"valeryanm.vscode-phpsab": {
			"supported": true
		},
		"bradlc.vscode-tailwindcss": {
			"supported": true
		},
		"bmewburn.vscode-intelephense-client": {
			"supported": true
		},
		"sadesyllas.vscode-workspace-switcher": {
			"supported": true
		},
		"mehedidracula.php-namespace-resolver": {
			"supported": true
		},
	},
	"terminal.integrated.fontSize": 12,
	"terminal.integrated.cursorStyle": "line",
	"terminal.integrated.cursorBlinking": true,
	"terminal.integrated.defaultLocation": "view",
	"terminal.integrated.defaultProfile.linux": "bash",
	"terminal.integrated.defaultProfile.windows": "Git Bash",
	// Extensions.
	"git.autofetch": true,
	"git.confirmSync": false,
	"git.enableSmartCommit": true,
	"redhat.telemetry.enabled": true,
	"typescript.suggest.paths": false,
	"javascript.format.enable": false,
	"javascript.updateImportsOnFileMove.enabled": "always",
	"emmet.includeLanguages": {
		"javascript": "javascriptreact"
	},
	"tailwindCSS.includeLanguages": {
		"javascript": "javascriptreact"
	},
	"stylelint.validate": [
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"markdown",
		"postcss",
		"sass",
		"scss",
		"source.css.styled",
		"source.markdown.math",
		"styled-css",
		"sugarss",
		"svelte",
		"typescript",
		"typescriptreact",
		"vue",
		"vue-html",
		"vue-postcss",
		"xml",
		"xsl"
	],
	"tailwindCSS.emmetCompletions": true,
	"css.validate": false,
	"less.validate": false,
	"scss.validate": false,
	"liveshare.presence": true,
	"php.suggest.basic": false,
	"php.validate.enable": false,
	"phpsab.snifferShowSources": true,
	"php-docblocker.returnGap": true,
	"php-docblocker.returnVoid": false,
	"php-docblocker.useShortNames": true,
	"php-docblocker.alignParams": true,
	"php-docblocker.alignReturn": true,
	"php-docblocker.paramDescription": true,
	"php-docblocker.returnDescription": true,
	"php-docblocker.classTemplate": {
		"message": {},
		"since": {
			"content": "@since ${###:1.0.0}",
			"gapAfter": true
		},
		"extra": {}
	},
	"php-docblocker.functionTemplate": {
		"message": {},
		"since": {
			"content": "@since ${###:1.0.0}",
			"gapAfter": true
		},
		"param": {},
		"return": {},
		"extra": {}
	},
	"php-docblocker.propertyTemplate": {
		"message": {},
		"since": {
			"content": "@since ${###:1.0.0}"
		},
		"var": {},
		"extra": {}
	},
	"intelephense.diagnostics.enable": false,
	"intelephense.stubs": [
		"apache",
		"bcmath",
		"bz2",
		"calendar",
		"com_dotnet",
		"Core",
		"ctype",
		"curl",
		"date",
		"dba",
		"dom",
		"enchant",
		"exif",
		"FFI",
		"fileinfo",
		"filter",
		"fpm",
		"ftp",
		"gd",
		"gettext",
		"gmp",
		"hash",
		"iconv",
		"imap",
		"intl",
		"json",
		"ldap",
		"libxml",
		"mbstring",
		"meta",
		"mysqli",
		"oci8",
		"odbc",
		"openssl",
		"pcntl",
		"pcre",
		"PDO",
		"pdo_ibm",
		"pdo_mysql",
		"pdo_pgsql",
		"pdo_sqlite",
		"pgsql",
		"Phar",
		"posix",
		"pspell",
		"readline",
		"Reflection",
		"session",
		"shmop",
		"SimpleXML",
		"snmp",
		"soap",
		"sockets",
		"sodium",
		"SPL",
		"sqlite3",
		"standard",
		"superglobals",
		"sysvmsg",
		"sysvsem",
		"sysvshm",
		"tidy",
		"tokenizer",
		"xml",
		"xmlreader",
		"xmlrpc",
		"xmlwriter",
		"xsl",
		"Zend OPcache",
		"zip",
		"zlib",
		"wordpress"
	],
	"intelephense.files.exclude": [
		"**/.git/**",
		"**/.svn/**",
		"**/.hg/**",
		"**/CVS/**",
		"**/.DS_Store/**",
		"**/node_modules/**",
		"**/bower_components/**",
		"**/vendor/**/{Tests,tests}/**",
		"**/.history/**",
		"**/vendor/**/vendor/**",
		"**/wp-admin/includes/noop.php"
	],
	"namespaceResolver.sortOnSave": false,
	"namespaceResolver.showMessageOnStatusBar": true,
	"material-icon-theme.folders.color": "#42a5f5",
	"material-icon-theme.activeIconPack": "react_redux",
	"vscodeWorkspaceSwitcher.paths": [
		"C:/Users/User/OneDrive/Workspace"
	],
	"vscodeWorkspaceSwitcher.showInExplorer": false,
	"vscodeWorkspaceSwitcher.showInActivityBar": false,
	"github-actions.org-features": true,
	"security.workspace.trust.untrustedFiles": "open",
	"[html]": {
		"editor.defaultFormatter": "vscode.html-language-features"
	},
	"[json]": {
		"editor.defaultFormatter": "vscode.json-language-features"
	},
	"bracket-pair-colorizer-2.depreciation-notice": false,
	"terminal.integrated.fontFamily": "monospace",
	"settingsSync.ignoredExtensions": [
		"usernamehw.errorlens"
	],
	"files.autoSave": "afterDelay",
	"editor.defaultFormatter": "esbenp.prettier-vscode",
	"[javascript]": {
		"editor.defaultFormatter": "<another formatter>"
	},
	"diffEditor.ignoreTrimWhitespace": false,
	"errorLens.enabled": false
}
EOF

echo "settings.json created successfully in $win_filepath."
