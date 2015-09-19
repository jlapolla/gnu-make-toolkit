# TARGET
# watch - automatically update targets when prerequisites change
#
# USAGE
# make watch WATCHLIST="<target_name>[ <target_name>[...]]"
#
# DESCRIPTION
# "watch.mk" creates the "watch" target. The "watch" target calls Make
# recursively in a continuous polling loop to update targets when target
# prerequisites change. Specify targets to watch on the command line by
# setting WATCHLIST to a list of target names.
#
# VARIABLES
# $(WATCHLIST)
# List of targets to poll for updates. WATCHLIST should be specified on
# the command line.
#
# $(__watch)
# Used to detect if "watch" target has already been defined.

ifndef __watch
__watch := 1

ifdef WATCHLIST
# "watch" target rule
.PHONY: watch
watch:
	$(info Watching "$(sort $(WATCHLIST))")
	$(info (Press Ctrl+Z to pause))
	$(info (Press Ctrl+C to quit))
	@while sleep 0.25; do \
	  for TARGET in $(sort $(WATCHLIST)); do \
	    $(MAKE) --no-print-directory -q $$TARGET >/dev/null 2>&1 || \
	    $(MAKE) --no-print-directory $$TARGET; \
	  done; \
	done;

else # ifdef WATCHLIST
# "watch" target rule (error version)
.PHONY: watch
watch:
	$(info Missing WATCHLIST. Usage is:)
	$(info make watch WATCHLIST="<target_name>[ <target_name>[...]]")
	@false

endif # ifdef WATCHLIST
endif # ifndef __watch
