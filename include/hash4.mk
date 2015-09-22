# DIRECTIVE
# hash4 - calculate 4 byte hash of input string
#
# USAGE
# $(call hash4,<string_to_hash>)
#
# DESCRIPTION
# The "hash4" function calculates the 4 byte hash value for the provided
# <string_to_hash>. The returned hash is encoded in hexadecimal, and has
# a total length of 8 characters.
#
# "hash4" does not generate cryptographically secure hashes. It is
# optimized for speed.
#
# ARGUMENTS
# <string_to_hash>
# The input string to calculate the hash for.
#
# RETURNS
# 4 byte hash of <string_to_hash>, as an 8 character hexadecimal string.

ifndef hash4
hash4 = $(shell printf '%s' "$(1)" | md5sum - | head -c 8 -)
endif
