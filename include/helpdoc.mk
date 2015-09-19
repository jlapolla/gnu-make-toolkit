# DIRECTIVE
# helpdoc - help documentation system
#
# USAGE
# $(call helpdoc,<target_name>,[<help_text>])
#
# DESCRIPTION
# The "helpdoc" function is used for adding distributed help
# documentation to a build system. When called, the "helpdoc" function
# registers <help_text> with <target_name>. A user can then run "make
# help HELPLIST=<target_name>" on the command line to view the
# <help_text> for <target_name>.
#
# "helpdoc.mk" also adds two standard targets to the build system:
# "help" and "helplist". These targets are described in more detail
# in the TARGETS section below.
#
# ARGUMENTS
# <target_name>
# The name of the target to register help documentation for.
#
# <help_text> [OPTIONAL]
# The help documentation to display for <target_name>. If no <help_text>
# is provided, running "make help HELPLIST=<target_name>" displays a
# message indicating that there is no help documentation available.
# <target_name> still appears in the output of the "helplist" target
# when no <help_text> is provided.
#
# RETURNS
# Empty string.
#
# VARIABLES
# $(__helpdoc_targets) [PRIVATE]
# List of all <target_name>'s registered with the "helpdoc" function.
# This list is used by the help and helplist targets.
#
# $(__helpdoc_text.<target_name>) [PRIVATE]
# Stores the <help_text> registered with <target_name>.
#
# $(__helpdoc_comma) [PRIVATE]
# Contains a comma (,) character.
#
# $(__helpdoc_newline) [PRIVATE]
# Contains a newline character sequence.
#
# $(__helpdoc_loop) [PRIVATE]
# A loop variable used internally by "helpdoc.mk".
#
# TARGETS
# help
# Standard target created by "helpdoc.mk". Type 'make help
# HELPLIST="<target_name>[ <target_name>[...]]"' to display the help
# documentation for each <target_name>. When specified without any
# HELPLIST, the bare "help" target displays a message introducing the
# the help documentation system (this target is a candidate for
# .DEFAULT_GOAL).
#
# helplist
# Standard target created by "helpdoc.mk". Displays a list of all
# <target_name> targets registered with the "helpdoc" function. Used for
# discovering available targets.

ifndef helpdoc

# Store ","
__helpdoc_comma := ,

# Store newline
define __helpdoc_newline


endef

# "helpdoc" function definition
helpdoc = $(eval __helpdoc_targets := $(sort $(__helpdoc_targets) $(1)))

ifdef HELPLIST
# Append to "helpdoc" function definition
helpdoc += $(if $(2),$(eval __helpdoc_text.$(1) := $(2)),)

# "help" target rule
.PHONY: help
$(call helpdoc,help,Show help documentation for targets given in the HELPLIST variable$(__helpdoc_comma) or show message introducing the help documentation system if no HELPLIST variable is provided)
help:
	$(foreach __helpdoc_loop,$(sort $(subst $(__helpdoc_newline), ,$(HELPLIST))),$(if $(findstring $(__helpdoc_loop),$(__helpdoc_targets)), \
	  $(info $(__helpdoc_loop):)$(if $(__helpdoc_text.$(__helpdoc_loop)),$(info $(__helpdoc_text.$(__helpdoc_loop))),$(info (no help documentation)))$(info ), \
	  $(info WARNING: Target not registered: $(__helpdoc_loop))$(info ) \
	))
	@true

else # ifdef HELPLIST
# "help" target rule (introduction version)
.PHONY: help
$(call helpdoc,help)
help:
	$(info Help Documentation)
	$(info ==================)
	$(info )
	$(info make helplist:)
	$(info List all targets registered with the help documentation system)
	$(info )
	$(info make help HELPLIST="<target_name>[ <target_name>[...]]":)
	$(info Show help documentation for each <target_name>)
	$(info )
	$(info make help:)
	$(info Show message introducing the help documentation system (this message))
	$(info )
	@true

endif # ifdef HELPLIST

# "helplist" target rule
.PHONY: helplist
$(call helpdoc,helplist,List all targets registered with the help documentation system)
helplist:
	$(foreach __helpdoc_loop,$(__helpdoc_targets),$(info $(__helpdoc_loop)))
	@true
endif
