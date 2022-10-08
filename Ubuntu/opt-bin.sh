printf '%s' "$PATH" | grep --quiet '\(^\|:\)/opt/bin\(:\|$\)' || export PATH="$PATH:/opt/bin"
