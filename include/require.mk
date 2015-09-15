# DIRECTIVE
# require - modular version of Make's "include" directive
#
# USAGE
# <exports> := $(call require,<path_to_makefile>)
#
# DESCRIPTION
# Sets the special $(d) variable, then includes the "required" Makefile.
# Used for working with modular Makefiles.
#
# The operation and syntax of this function was inspired by the Node.js
# module loading system <https://nodejs.org/api/modules.html>.
#
# ARGUMENTS
# <path_to_makefile>
# The path to the "required" Makefile. This can be an absolute path, or
# a relative path. A relative path MUST be prefixed with $(d) (see $(d)
# in VARIABLES).
#
# RETURNS
# The exports list declared by the "required" Makefile.
#
# VARIABLES
# $(d)
# The directory of the "required" Makefile (either an absolute path, or
# relative to the current working directory that Make was run from). The
# "required" Makefile MUST prefix all relative file paths with $(d).
# Recipes in the "required" Makefile MUST NOT assume that $(d) is the
# current working directory. Instead, use $(d) in the recipe such that
# the recipe can be run from any working directory. NOTE: $(d) includes
# a trailing slash.
#
# $(__require_stack) [PRIVATE]
# The stack of $(d) variables used in recursive calls to "require".
# "require" uses $(__require_stack) to reset $(d) to the current
# directory after it is done including the "required" Makefile.
#
# $(exports)
# A list of targets declared by the "required" Makefile. The "required"
# Makefile MUST set $(exports) to indicate the targets available in the
# module. The Makefile that called "require" MUST NOT depend on targets
# that are NOT listed in the "required" Makefile's $(exports). The
# Makefile that called "require" cannot access $(exports) directly.
# Instead, it must use the value returned from "require".
#
# CODE COMMENTS
# Line 1  : Apply "sort" function to exports list returned on Line 6
# Line 2  : Reset exports list to empty string
# Line 3  : Push new directory onto __require_stack
# Line 4  : Set d to new directory
# Line 5  : Include the Makefile at "path_to_makefile"
# Line 6  : Return exports list declared by the included "path_to_makefile"
# Line 7  : Pop directory from __require_stack
# Line 8  : Reset d to old directory
# Line 9  : Reset exports list to empty string
# Line 10 : Terminate "sort" function arguments list

ifndef require
require = $(sort \
  $(eval exports :=) \
  $(eval __require_stack := $(__require_stack) $(dir $(1))) \
  $(eval d := $(lastword $(__require_stack))) \
  $(eval include $(1)) \
  $(exports) \
  $(eval __require_stack := $(wordlist 2,$(words $(__require_stack)),x $(__require_stack))) \
  $(eval d := $(lastword $(__require_stack))) \
  $(eval exports :=) \
)
endif
