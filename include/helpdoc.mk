# DIRECTIVE
# helpdoc - help documentation generator
#
# USAGE
# $(call helpdoc,<target_name>,<help_text>)
#
# DESCRIPTION
#
# ARGUMENTS
# <target_name>
#
# <help_text>
#
# RETURNS
# Empty string.
#
# VARIABLES
# $(__helpdoc_template) [PRIVATE]
#
# $(__helpdoc_targets) [PRIVATE]
#
# $(__helpdoc_loop) [PRIVATE]
#
# TARGETS
# help.<target_name>
#
# help
#
# help-show-all
#
# help-list-all

ifndef helpdoc

# Rule template for targets created with "helpdoc" function
define __helpdoc_template
.PHONY: help.$(1)
help.$(1):
	$$(info $(1):)
	$$(info $(2))
	$$(info )
	@true
endef

# "helpdoc" function definition
helpdoc = $(if \
  $(eval $(call __helpdoc_template,$(1),$(2))) \
  $(eval __helpdoc_targets := $(sort $(__helpdoc_targets) $(1))) \
,,)

# "help" target rule
.PHONY: help
$(call helpdoc,help,Show message introducing the help documentation system)
help:
	$(info Help Documentation)
	$(info ==================)
	$(info )
	$(info make help-show-all:)
	$(info Show help for all targets with available help documentation)
	$(info )
	$(info make help-list-all:)
	$(info List all targets with available help documentation)
	$(info )
	$(info make help.<target_name>:)
	$(info Show help for <target_name>)
	$(info )
	$(info make help:)
	$(info Show message introducing the help documentation system (this message))
	$(info )
	@true

# "help-show-all" target rule
.PHONY: help-show-all
$(call helpdoc,help-show-all,Show help for all targets with available help documentation)
help-show-all:
	@$(MAKE) --no-print-directory $(addprefix help.,$(__helpdoc_targets))

# "help-list-all" target rule
.PHONY: help-list-all
$(call helpdoc,help-list-all,List all targets with available help documentation)
help-list-all:
	$(foreach __helpdoc_loop,$(__helpdoc_targets),$(info $(__helpdoc_loop)))
	@true
endif
