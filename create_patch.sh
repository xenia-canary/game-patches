#!/usr/bin/env bash

prompt_error() {
    read -n1 -rp $'\e[31mERROR:\e[0m'" $1"$'\n'$'\n''Press any key to continue . . . '
    exit 1
}
if [ ! -d patches ]; then
    prompt_error "patches directory doesn't exist!"
fi

xenia_log_default='xenia.log'
if [ -f "$xenia_log_default" ]; then
    xenia_log="$xenia_log_default"
elif [ -f "$1" ]; then
    xenia_log="$1"
else
    prompt_error "Log doesn't exist!"
fi
echo "Found $xenia_log"

echo 'Checking log...'
xenia_log_cleaned=$(grep -oP ' {7}Title ID: [0-9A-F]{8}|i> [0-9A-F]{8} Title name:.+|i> [0-9A-F]{8} Module hash: [0-9A-F]{16} for.+' "$xenia_log" | sort -u)
new_patch_title_ids=($(grep -oP '(?<= {7}Title ID: )[0-9A-F]{8}' <<<"$xenia_log_cleaned"))
readarray -t new_patch_title_names < <(grep -oP '(?<=i> [0-9A-F]{8} Title name: ).+' <<<"$xenia_log_cleaned")
new_patch_hashes=($(grep -oP '(?<=i> [0-9A-F]{8} Module hash: )[0-9A-F]{16}(?= for .+)' <<<"$xenia_log_cleaned"))
new_patch_hashes_modules=($(grep -oP '(?<=i> [0-9A-F]{8} Module hash: [0-9A-F]{16} for ).+' <<<"$xenia_log_cleaned"))
set -e
prompt() {
    if [ -n "$valid_input_length" ] && [ $valid_input_length != nonempty ]; then
        read -rn $valid_input_length -p $'\n'"$1"$'\n' "$2"
    else
        read -rp $'\n'"$1"$'\n' "$2"
    fi
    local user_input="${!2,,}"
    if [ "$user_input" = q ] || [ "$user_input" = quit ]; then
        exit
    fi
    if [ -n "$valid_input_length" ]; then
        if [[ ( -z "$user_input" && $valid_input_length = nonempty ) || ( ${#user_input} != $valid_input_length && $valid_input_length != nonempty && -z "$minimum_input_length" ) || ( -n "$minimum_input_length" && ${#user_input} -lt $minimum_input_length ) ]]; then
            ${FUNCNAME[0]} "$@"
        fi
    fi
    if [ -n "$valid_input_params" ]; then
        for valid_param in "${valid_input_params[@]}"; do
            if [ "$user_input" = "$valid_param" ]; then
                local valid_input=true
                break
            fi
        done
        if [ -z $valid_input ]; then
            ${FUNCNAME[0]} "$@"
        elif [ -z "$3" ]; then
            unset valid_input_params
        fi
    fi
    if [ -n "$valid_input_regex" ]; then
        if [[ "$user_input" =~ $valid_input_regex ]]; then
            unset valid_input_regex
        else
            ${FUNCNAME[0]} "$@"
        fi
    fi
    unset valid_input_length
}
check_multiple_choice() {
    local array_2="$2"'[@]'
    local expanded_2=("${!array_2}")
    if [ ${#expanded_2[@]} -gt 1 ]; then
        if [ ${#expanded_2[@]} -le 9 ]; then
            valid_input_length=1
        else
            valid_input_length=2
            minimum_input_length=1
        fi
        new_patch_thing_prompt="What is the $1 of your patch?  [(Q)uit]"$'\n'
        for (( i=0; i <= ( ${#expanded_2[@]} - 1 ); i++ )); do
            valid_input_key_number=$(($i + 1))
            valid_input_params+=($valid_input_key_number)
            if [ -n "$4" ]; then
                local expanded_4="$4"'[$i]'
                local new_patch_thing_prompt_addendum=" - ${!expanded_4}"
            fi
            if [ $valid_input_key_number -le 9 ] && [ ${#expanded_2[@]} -ge 10 ]; then
                if [ -z "$space" ]; then
                    local space=' '
                fi
            else
                unset space
            fi
            local new_patch_thing_prompt+=" ${space}${valid_input_key_number}. ${expanded_2[$i]}$new_patch_thing_prompt_addendum"$'\n'
        done
        prompt "${new_patch_thing_prompt/%$'\n'}" new_patch_thing_choice
        declare -g "$3"="${expanded_2[($new_patch_thing_choice - 1)]}"
        if [ -n "$4" ] && [ -n "$5" ]; then
            local unexpanded_4_user_choice="$4"\[$(($new_patch_thing_choice - 1))\]
            declare -g "$5"="${!unexpanded_4_user_choice}"
        fi
    elif [ ${#expanded_2[@]} -gt 0 ]; then
        declare -g "$3"="$expanded_2"
        if [ -n "$4" ] && [ -n "$5" ]; then
            declare -g "$5"="${!expanded_4}"
        fi
    fi
}
check_multiple_choice 'title ID' new_patch_title_ids new_patch_title_id
check_multiple_choice 'title name' new_patch_title_names new_patch_title_name
new_patch_title_name=$(tr -d '"\\' <<<$new_patch_title_name) # " and \ are unsafe even for TOML
check_multiple_choice hash new_patch_hashes new_patch_hash new_patch_hashes_modules new_patch_hash_module
if [ -n "$new_patch_title_id" ] && [ -n "$new_patch_title_name" ] && [ -n "$new_patch_hash" ] && [ -n "$new_patch_hash_module" ]; then
    new_patch_filename="$new_patch_title_id - $(tr -d '(/|\\|:|\*|\?|\"|<|>|\|)' <<<${new_patch_title_name}.toml)"
    echo $'\n'$'\n'"Patch filename: $new_patch_filename"$'\n'"Patch hash:     $new_patch_hash"$'\n'
else
    prompt_error 'Title ID, title name, and/or hash are missing from the log.'$'\n''Make sure log_level is set to 2 in the Xenia config.'
fi

for existing_patch in patches/*; do
    if [[ "$existing_patch" =~ "$new_patch_title_id" ]]; then
        if [[ "$existing_patch" =~ "$new_patch_filename" ]]; then
            if [ -z "$patch_conflict_level" ]; then
                echo -e '\e[1;33mWARNING:\e[0m Patch already exists;'
                patch_conflict_level=2
            fi
            echo -n " Matched with: $existing_patch"
        else
            if [ -z "$patch_conflict_level" ]; then
                echo -e '\e[1;33mWARNING:\e[0m Patch might already exist;'
                patch_conflict_level=1
            fi
            echo -n " Partially matched with: $existing_patch"
        fi
    fi
done

if [ -n "$patch_conflict_level" ]; then
    valid_input_length=1
    valid_input_params=y
    case "$patch_conflict_level" in
        1)
            prompt 'Potentially overwrite patch?            [(Y)es, (Q)uit]' answer;;
        2)
            prompt 'Overwrite patch?                        [(Y)es, (Q)uit]' answer;;
    esac
fi

valid_input_length=nonempty
prompt $'\n''What is the name of your patch?         [(Q)uit]' new_patch_name
prompt 'What is the description of your patch?  [(Q)uit]' new_patch_desc
valid_input_length=nonempty
prompt 'Who are the authors of your patch?      [(Q)uit]' new_patch_author

# New patch is_enabled
valid_input_length=1
valid_input_params=(t f)
prompt 'Do you want this patch to be enabled?   [(t)rue, (f)alse, (q)uit]' new_patch_is_enabled keep_params
case "$new_patch_is_enabled" in
    ${valid_input_params[0]})
        new_patch_is_enabled=true;;
    ${valid_input_params[1]})
        new_patch_is_enabled=false;;
esac
unset valid_input_params

# New patch address
valid_input_length=8
valid_input_regex_hex='[0-9A-Fa-f]{$valid_input_length}'
eval valid_input_regex=$valid_input_regex_hex # eval might be bad
prompt $'\n''What is the address of your patch?      [(Q)uit]' new_patch_address

# New patch type
valid_patch_types=(be{8,16,32,64} f{32,64})
valid_input_length=1
valid_input_params=({1..6})
prompt $'\n''What is the type of your patch?         [(Q)uit]'$'\n'" 1. ${valid_patch_types[0]}"$'\n'" 2. ${valid_patch_types[1]}"$'\n'" 3. ${valid_patch_types[2]}"$'\n'" 4. ${valid_patch_types[3]}"$'\n'" 5. ${valid_patch_types[4]}"$'\n'" 6. ${valid_patch_types[5]}" new_patch_type_input
case "$new_patch_type_input" in
    1)
        new_patch_type=${valid_patch_types[0]}
        valid_input_length=2;;
    2)
        new_patch_type=${valid_patch_types[1]}
        valid_input_length=4;;
    3)
        new_patch_type=${valid_patch_types[2]}
        valid_input_length=8;;
    4)
        new_patch_type=${valid_patch_types[3]}
        valid_input_length=16;;
    5)
        new_patch_type=${valid_patch_types[4]}
        valid_input_length=nonempty;; # This probably isn't right
    6)
        new_patch_type="${valid_patch_types[5]}"
        valid_input_length=nonempty;; # This probably isn't right
esac
if [ $valid_input_length != nonempty ]; then
    eval valid_input_regex=$valid_input_regex_hex # eval might be bad
fi
prompt $'\n''What is the value of your patch?        [(Q)uit]' new_patch_value

new_patch_path="patches/$new_patch_filename"
new_patch_contents="title_name = \"${new_patch_title_name}\"
title_id = \"${new_patch_title_id}\"
hash = \"${new_patch_hash}\" # $new_patch_hash_module

[[patch]]
    name = \"${new_patch_name^}\""
if [ -n "$new_patch_desc" ]; then
    new_patch_contents+="
    desc = \"${new_patch_desc^}\""
fi
new_patch_contents+="
    author = \"${new_patch_author}\"
    is_enabled = $new_patch_is_enabled

    [[patch.${new_patch_type}]]
        address = 0x${new_patch_address^^}
        value = 0x${new_patch_value^^}"
echo "$new_patch_contents" > "$new_patch_path"
echo -e $'\n'$'\n'"\e[32mPatch '$new_patch_path' created successfully! \e[0m"

valid_input_length=1
valid_input_params=(o p)
prompt 'What would you like to do?              [(O)pen patch, (P)review patch, (Q)uit]' answer keep_params
case $answer in
    ${valid_input_params[0]})
        if [ ! "$OSTYPE" = cygwin ] && [ ! "$OSTYPE" = msys ]; then
            editors=($EDITOR {xdg-,}open code{,-insiders} codium gedit atom emacs notepadqq subl nano pico {g,n}vim vi)
            for editor in "${editors[@]}"; do
                if hash $editor 2>/dev/null; then
                    break
                fi
            done
            $editor "$new_patch_path" &
        else
            powershell -NoLogo -command ./\""$new_patch_path\"" &
        fi;;
    ${valid_input_params[1]})
        echo $'\n'$'\n'$'\n'"$(cat "$new_patch_path")"
        read -n1 -rp $'\n'$'\n''Press any key to continue . . . ';;
esac
unset valid_input_params
