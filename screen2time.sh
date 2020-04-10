#!/usr/bin/env bash
#params
dd_api_key=$1
dd_app_key=$2
screen_id=$3
curl -sX GET "https://app.datadoghq.com/api/v1/screen/${screen_id}?api_key=${dd_api_key}&application_key=${dd_app_key}" \
 | jq '{
         title: .board_title,
         description: .board_title,
         template_variables: .template_variables,
         graphs: [.widgets[] | {title: .title_text, definition: .tile_def}]
       }' \
 | curl -sX POST -H "Content-type: application/json" -d @- \
     "https://app.datadoghq.com/api/v1/dash?api_key=${dd_api_key}&application_key=${dd_app_key}"
if [ $? != 0 ]; then
    exit 1
fi
