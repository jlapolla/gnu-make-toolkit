ifndef require # Include guard.
# Function "require".
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
# 1. Reset exports list.
# 2. Push new directory onto _d_list_.
# 3. Set d to new directory.
# 4. Include the Makefile at path_to_makefile.
# 5. Pop new directory from _d_list_.
# 6. Reset d to old directory.
# 7. Return exports list set by the required Makefile.
# 8. Reset exports list.
endif
