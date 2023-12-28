#!/usr/bin/env bash
source log.sh

function send_msg_to_chat_usage(){
    yellow='\033[1;33m'
    reset='\033[0m'
    echo -e "${yellow}"
    echo -e "\n=== Send Message to GoogleChat Usage ===\n"
    echo -e "Example: send_msg_to_chat <message> [user_id]...\n\n\n"
    echo -e "send_msg_to_chat \"Hello, this is a message from Shell script!\" \"113061970078918879376\" \"113061970078918879376\""
    echo -e "${reset}"
}

function send_msg_to_chat() {
# send hangoutschat
    if [ $# -lt 1 ];then
        send_msg_to_chat_usage
        log_fatal "Message parameter is required"
    fi
    CHATROOM_URL="https://chat.googleapis.com/v1/spaces/xxxxxxxxxxx/messages?key=xxxxxxxxxxx&token=xxxxxxxxxxx"
    msg=$1;shift

    for uid in $@;do
        mention_users="${mention_users} <users/${uid}>"
    done

    curl -s -X POST -H "Content-Type: application/json" -d '{"text":"'"${msg}\n${mention_users}"'"}' "${CHATROOM_URL}" > /dev/null
}

# send_msg_to_chat
# send_msg_to_chat "test"
# send_msg_to_chat "test" "113061970078918879376" "113061970078918879376"