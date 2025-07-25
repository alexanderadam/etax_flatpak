#!/bin/sh
# Color and emoji helpers
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
EMOJI_RUN="🚀"
EMOJI_OK="✅"
EMOJI_ERR="❌"
EMOJI_FIND="🔍"
EMOJI_INSTALL="📦"
EMOJI_JAVA="☕"

set -e
cd /app
echo -e "${BLUE}${EMOJI_RUN} Starting eTax Zug Flatpak launcher...${NC}"

# Use OpenJDK extension if available
if [ -d "/app/extensions/org.freedesktop.Sdk.Extension.openjdk" ]; then
	export JAVA_HOME="/app/extensions/org.freedesktop.Sdk.Extension.openjdk"
	export PATH="$JAVA_HOME/bin:$PATH"
fi

# App data dir
APPDIR="${XDG_DATA_HOME:-$HOME/.var/app/ch.zg.etax/data}/etaxzug"
TARGETDIR="$APPDIR/etaxzug_inst"

mkdir -p "$APPDIR"
cd "$APPDIR"
echo -e "${BLUE}${EMOJI_FIND} Working directory: $APPDIR${NC}"

INSTALLER_SOURCE="/app/extra/etax_installer.zip"
INSTALLER_TYPE="zip"

if [ ! -f "$INSTALLER_SOURCE" ]; then
	echo -e "${RED}${EMOJI_ERR} No installer zip found at $INSTALLER_SOURCE!${NC}"
	exit 1
fi

# Find the newest eTax.zug_*_nP directory in $HOME
ETAX_APP_DIR=$(find "$HOME" -maxdepth 1 -type d -name 'eTax.zug_*_nP' | sort -Vr | head -n1)
if [ -n "$ETAX_APP_DIR" ]; then
	echo -e "${BLUE}${EMOJI_FIND} Found app directory: $ETAX_APP_DIR${NC}"
	# Prefer .desktop file (symlink or file)
	ETAX_DESKTOP=$(find "$ETAX_APP_DIR" -maxdepth 1 -type l -name '*.desktop' | sort -Vr | head -n1)
	if [ -z "$ETAX_DESKTOP" ]; then
		ETAX_DESKTOP=$(find "$ETAX_APP_DIR" -maxdepth 1 -type f -name '*.desktop' | sort -Vr | head -n1)
	fi
	if [ -n "$ETAX_DESKTOP" ]; then
		if [ -L "$ETAX_DESKTOP" ]; then
			TARGET_DESKTOP=$(readlink -f "$ETAX_DESKTOP")
		else
			TARGET_DESKTOP="$ETAX_DESKTOP"
		fi
		EXEC_LINE=$(grep -E '^Exec=' "$TARGET_DESKTOP" | head -n1 | sed 's/^Exec=//')
		if echo "$EXEC_LINE" | grep -q '^"'; then
			EXEC_CMD_CLEAN=$(echo "$EXEC_LINE" | sed -E 's/^"([^"]+)".*/\1/')
		else
			EXEC_CMD_CLEAN=$(echo "$EXEC_LINE" | awk '{print $1}')
		fi
		if [ -z "$EXEC_CMD_CLEAN" ]; then
			echo -e "${RED}${EMOJI_ERR} No Exec line found in $TARGET_DESKTOP. Directory listing:${NC}"
			ls -l "$ETAX_APP_DIR"
			exit 1
		fi
		if [ "${EXEC_CMD_CLEAN#/}" = "$EXEC_CMD_CLEAN" ]; then
			EXEC_PATH="$ETAX_APP_DIR/$EXEC_CMD_CLEAN"
		else
			EXEC_PATH="$EXEC_CMD_CLEAN"
		fi
		if [ ! -x "$EXEC_PATH" ]; then
			echo -e "${RED}${EMOJI_ERR} Exec target $EXEC_PATH is not executable!${NC}"
			exit 1
		fi
		echo -e "${GREEN}${EMOJI_OK} Executing: $EXEC_PATH $*${NC}"
		exec "$EXEC_PATH" "$@"
	fi
	# Fallback: main binary (not .desktop, not .jar, not uninstall)
	ETAX_BIN=$(find "$ETAX_APP_DIR" -maxdepth 1 -type f -executable ! -name '*.desktop' ! -name '*.jar' ! -iname 'uninstall' | sort -Vr | head -n1)
	if [ -n "$ETAX_BIN" ]; then
		echo -e "${GREEN}${EMOJI_OK} Executing main binary: $ETAX_BIN $*${NC}"
		exec "$ETAX_BIN" "$@"
	fi
	# Fallback: .jar
	ETAX_JAR=$(find "$ETAX_APP_DIR" -maxdepth 1 -type f -name '*.jar' | sort -Vr | head -n1)
	if [ -n "$ETAX_JAR" ]; then
		echo -e "${GREEN}${EMOJI_OK} Executing: java -jar $ETAX_JAR $*${NC}"
		exec java -jar "$ETAX_JAR" "$@"
	fi
	echo -e "${RED}${EMOJI_ERR} No suitable launcher (.desktop, binary, .jar) found in $ETAX_APP_DIR. Directory listing:${NC}"
	ls -l "$ETAX_APP_DIR"
	exit 1
fi

# If not installed, run the installer and remove any old installer scripts before
rm -f ./eTaxZGnP*_64bit.sh ./installer.sh
if [ "$INSTALLER_TYPE" = "zip" ]; then
	echo -e "${YELLOW}${EMOJI_INSTALL} Unzipping installer: $INSTALLER_SOURCE${NC}"
	unzip -qo "$INSTALLER_SOURCE"
	INSTALLER_SH_LOCAL=$(find . -maxdepth 1 -type f -name 'eTaxZGnP*_64bit.sh' | sort -Vr | head -n1)
	if [ -z "$INSTALLER_SH_LOCAL" ]; then
		 echo -e "${RED}${EMOJI_ERR} No installer script found after unzipping $INSTALLER_SOURCE!${NC}"
		 exit 1
	fi
	chmod +x "$INSTALLER_SH_LOCAL"
	echo -e "${GREEN}${EMOJI_OK} Executing installer: $INSTALLER_SH_LOCAL --target $TARGETDIR --noexec -q${NC}"
	"$INSTALLER_SH_LOCAL" --target "$TARGETDIR" --noexec -q || "$INSTALLER_SH_LOCAL" -q
else
	echo -e "${YELLOW}${EMOJI_INSTALL} Copying installer script: $INSTALLER_SOURCE${NC}"
	cp -f "$INSTALLER_SOURCE" ./installer.sh
	chmod +x ./installer.sh
	echo -e "${GREEN}${EMOJI_OK} Executing installer: ./installer.sh --target $TARGETDIR --noexec -q${NC}"
	./installer.sh --target "$TARGETDIR" --noexec -q || ./installer.sh -q
fi

# Find and launch the stuff to execute
ETAX_APP_DIR=$(find "$HOME" -maxdepth 1 -type d -name 'eTax.zug_*_nP' | sort -Vr | head -n1)
if [ -n "$ETAX_APP_DIR" ]; then
	echo -e "${BLUE}${EMOJI_FIND} (Post-install) Found app directory: $ETAX_APP_DIR${NC}"
	ETAX_DESKTOP=$(find "$ETAX_APP_DIR" -maxdepth 1 -type l -name '*.desktop' | sort -Vr | head -n1)
	if [ -z "$ETAX_DESKTOP" ]; then
		ETAX_DESKTOP=$(find "$ETAX_APP_DIR" -maxdepth 1 -type f -name '*.desktop' | sort -Vr | head -n1)
	fi
	if [ -n "$ETAX_DESKTOP" ]; then
		if [ -L "$ETAX_DESKTOP" ]; then
			TARGET_DESKTOP=$(readlink -f "$ETAX_DESKTOP")
		else
			TARGET_DESKTOP="$ETAX_DESKTOP"
		fi
		EXEC_LINE=$(grep -E '^Exec=' "$TARGET_DESKTOP" | head -n1 | sed 's/^Exec=//')
		if echo "$EXEC_LINE" | grep -q '^"'; then
			EXEC_CMD_CLEAN=$(echo "$EXEC_LINE" | sed -E 's/^"([^"]+)".*/\1/')
		else
			EXEC_CMD_CLEAN=$(echo "$EXEC_LINE" | awk '{print $1}')
		fi
		if [ -z "$EXEC_CMD_CLEAN" ]; then
			echo -e "${RED}${EMOJI_ERR} (Post-install) No Exec line found in $TARGET_DESKTOP. Directory listing:${NC}"
			ls -l "$ETAX_APP_DIR"
			exit 1
		fi
		if [ "${EXEC_CMD_CLEAN#/}" = "$EXEC_CMD_CLEAN" ]; then
			EXEC_PATH="$ETAX_APP_DIR/$EXEC_CMD_CLEAN"
		else
			EXEC_PATH="$EXEC_CMD_CLEAN"
		fi
		if [ ! -x "$EXEC_PATH" ]; then
			echo -e "${RED}${EMOJI_ERR} (Post-install) Exec target $EXEC_PATH is not executable!${NC}"
			exit 1
		fi
		echo -e "${GREEN}${EMOJI_OK} (Post-install) Executing: $EXEC_PATH $*${NC}"
		exec "$EXEC_PATH" "$@"
	fi
	ETAX_BIN=$(find "$ETAX_APP_DIR" -maxdepth 1 -type f -executable ! -name '*.desktop' ! -name '*.jar' ! -iname 'uninstall' | sort -Vr | head -n1)
	if [ -n "$ETAX_BIN" ]; then
		echo -e "${GREEN}${EMOJI_OK} (Post-install) Executing: $ETAX_BIN $*${NC}"
		exec "$ETAX_BIN" "$@"
	fi
	ETAX_JAR=$(find "$ETAX_APP_DIR" -maxdepth 1 -type f -name '*.jar' | sort -Vr | head -n1)
	if [ -n "$ETAX_JAR" ]; then
		echo -e "${GREEN}${EMOJI_OK} (Post-install) Executing: java -jar $ETAX_JAR $*${NC}"
		exec java -jar "$ETAX_JAR" "$@"
	fi
	echo -e "${RED}${EMOJI_ERR} (Post-install) No suitable launcher (.desktop, binary, .jar) found in $ETAX_APP_DIR. Directory listing:${NC}"
	ls -l "$ETAX_APP_DIR"
	exit 1
fi

echo -e "${YELLOW}${EMOJI_FIND} No installed eTax Zug app directory with desktop file found in $HOME.${NC}"
echo -e "${RED}${EMOJI_ERR} Could not find installed eTax Zug app in your home directory.${NC}"
exit 1
