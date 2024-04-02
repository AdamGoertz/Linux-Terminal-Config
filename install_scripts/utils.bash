version_ge() {
    printf '%s\n' "$2" "$1" | sort -C -V
}

get_version() {
    $1 --version | grep -oE [0-9]+\.?[0-9]*\.?[0-9]*$
}

command_version_ge() {
    command -v $1 &> /dev/null && version_ge $(get_version $1) $2
}
