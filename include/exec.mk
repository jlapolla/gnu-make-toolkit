# DIRECTIVE
# exec - execute command and fail on error
#
# USAGE
# $(call exec,<command>,[<error_msg>])
#
# DESCRIPTION
# The "exec" function executes a command using $(shell) and interprets
# its exit status. If the exit status is non-zero, "exec" generates an
# error displaying the provided <error_msg>, and Make exits with error.
# If no <error_msg> was provided, the <command> may fail silently.
#
# "exec" DOES NOT print <command> before running it. "exec" DOES NOT
# print the output of <command>.
#
# ARGUMENTS
# <command>
# The shell command to execute.
#
# <error_msg> [OPTIONAL]
# The error message to display if <command> has a non-zero exit status.
# If <error_msg> is provided, Make will exit with error if <command> has
# a non-zero exit status. If <error_msg> is not provided, <command> may
# fail silently
#
# RETURNS
# Empty string.

ifndef exec
exec = $(if $(filter 0,$(lastword $(shell $(1)$(if $(filter %;,$(lastword $(1))),, ;) printf ' %s' $$?))),,$(if $(2),$(error $(2)),))
endif
