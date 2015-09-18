# DIRECTIVE
# require - modular version of Make's "include" directive
#
# USAGE
# <exports> := $(call require,<path_to_makefile>[ <path_to_makefile[...]])
#
# DESCRIPTION
# Sets the special $(d) variable (described in the VARIABLES section
# below), then includes the "required" Makefiles. Used for working with
# modular Makefiles.
#
# The operation and syntax of this function is inspired by the Node.js
# module loading system <https://nodejs.org/api/modules.html>.
#
# ARGUMENTS
# <path_to_makefile>
# The path to the "required" Makefile. This can be an absolute path, or
# a relative path. A relative path MUST be prefixed with $(d) (see $(d)
# in VARIABLES).
#
# RETURNS
# The merged exports list declared by all the "required" Makefiles.
#
# VARIABLES
# $(d)
# The directory of the "required" Makefile (either an absolute path, or
# relative to the current working directory that Make was run from). The
# "required" Makefile MUST prefix all relative file paths with $(d).
# Recipes in the "required" Makefile MUST NOT assume that $(d) is the
# current working directory. Instead, use $(d) in the recipe such that
# the recipe can be run from any working directory. $(d) is similar to
# PHP's magic constant __DIR__
# <https://secure.php.net/manual/en/language.constants.predefined.php>.
# NOTE: $(d) includes a trailing slash.
#
# $(exports)
# A list of targets declared by the "required" Makefile. The "required"
# Makefile MUST set $(exports) to indicate the targets available in the
# module. The Makefile that called "require" MUST NOT depend on targets
# that are NOT listed in the "required" Makefile's $(exports). The
# Makefile that called "require" cannot access $(exports) directly.
# Instead, it must use the value returned from "require".
#
# $(__require_stack) [PRIVATE]
# The stack of $(d) variables used in recursive calls to "require".
# "require" uses $(__require_stack) to reset $(d) to the current
# directory after it is done including a "required" Makefile.
#
# $(__require_loop) [PRIVATE]
# A loop variable used internally by "require.mk".
#
# CODE COMMENTS
# Line 1  : Apply "sort" function to exports list returned on Line 7
# Line 2  : Iterate over <path_to_makefile> list
# Line 3  : Reset exports list to empty string
# Line 4  : Push new directory onto __require_stack
# Line 5  : Set d to new directory
# Line 6  : Include the next Makefile in <path_to_makefile>
# Line 7  : Return exports list declared by the included <path_to_makefile>
# Line 8  : Pop directory from __require_stack
# Line 9  : Reset d to old directory
# Line 10 : Terminate "foreach" loop
# Line 11 : Reset exports list to empty string
# Line 12 : Terminate "sort" function

ifndef require
require = $(sort \
  $(foreach __require_loop,$(1), \
    $(eval exports :=) \
    $(eval __require_stack := $(__require_stack) $(dir $(__require_loop))) \
    $(eval d := $(lastword $(__require_stack))) \
    $(eval include $(__require_loop)) \
    $(exports) \
    $(eval __require_stack := $(wordlist 2,$(words $(__require_stack)),x $(__require_stack))) \
    $(eval d := $(lastword $(__require_stack))) \
  ) \
  $(eval exports :=) \
)
endif
