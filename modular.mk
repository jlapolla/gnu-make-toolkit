ifndef require # Include guard
# Function "require"
#
# Usage:
# exports := $(call require,path_to_makefile)
require = $(strip \
  $(eval exports :=) \
  $(eval _d_list_ := $(_d_list_) $(dir $(1))) \
  $(eval d := $(lastword $(_d_list_))) \
  $(eval include $(1)) \
  $(eval _d_list_ := $(wordlist 2,$(words $(_d_list_)),x $(_d_list_))) \
  $(eval d := $(lastword $(_d_list_))) \
  $(exports) \
  $(eval exports :=) \
)
# Explanation:
# Line 1  : Apply "strip" function to exports list returned on Line 8
# Line 2  : Reset exports list to empty string
# Line 3  : Push new directory onto _d_list_
# Line 4  : Set d to new directory
# Line 5  : Include the Makefile at "path_to_makefile"
# Line 6  : Pop directory from _d_list_
# Line 7  : Reset d to old directory
# Line 8  : Return exports list set by the included "path_to_makefile"
# Line 9  : Reset exports list to empty string
# Line 10 : Terminate "strip" function arguments list
endif
