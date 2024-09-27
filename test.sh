TOKEN="7659597611:AAGCa_pylJU71keQhN3U3ovPaOAWlg2jzGc"
last_update_id=0
answered_messages=()

send_message() {
    local CHAT_ID="$1"
    local message="$2"
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=$message"
}

get_updates() {
    curl -s -X GET "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update_id"
}

process_updates() {
    updates=$(get_updates)
    if [[ "$updates" != "" ]]; then
        latest_update_id=$(echo "$updates" | jq '.result | .[-1].update_id')
        last_update_id=$((latest_update_id + 1))

        for row in $(echo "$updates" | jq -r '.result[] | @base64'); do
            _jq() {
                echo ${row} | base64 --decode | jq -r ${1}
            }
            message_text=$(_jq '.message.text')
            message_id=$(_jq '.message.message_id')
            id=$(_jq '.message.chat.id')
            username=$(_jq '.message.from.username')
            message_id=$(_jq '.message.message_id')
            usr=$(_jq '.message.chat.first_name')

            if [[ ! " ${answered_messages[@]} " =~ " ${message_id} " ]]; then
                if [[ "$message_text" == "/get" ]]; then
                    message_content=$(<out.txt)
                    send_message "$id" "$message_content" &> /dev/null
                fi
                answered_messages+=("$message_id")
            fi
        done
    fi
}

while true; do
    process_updates
done