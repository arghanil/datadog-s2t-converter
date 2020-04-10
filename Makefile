check-var = $(if $(strip $($1)),,$(error var for "$1" is empty))

default: help

require_api:
	$(call check-var,api_key)

require_app:
	$(call check-var,app_key)

require_screen:
	$(call check-var,screen_id)

dashboard/stt: require_api require_app require_screen ## Converts a screen dashboard to time dashboard. E.g. api_key=REDACTED app_key=REDACTED screen_id=319158
	@echo "Executing convertion command..."
	@bash ./screen2time.sh $(api_key) $(app_key) $(screen_id) > temp.f
	@echo "Dashboard convertion command executed."
	@echo "Dashboard URL -"
	@cat temp.f | jq '.url' | sed s/\"//g

help: ## This helps
	@awk 'BEGIN {FS = ":.*?## "} /^[\/a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36mdatadog-s2t-converter \033[0m%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
