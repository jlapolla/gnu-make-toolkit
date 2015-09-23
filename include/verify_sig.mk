# RECIPE
# verify_sig - verify cryptographic signatures
#
# USAGE
# $(call verify_sig,<signature>,<signed_file>)
#
# DESCRIPTION
# The "verify_sig" recipe verifies a signed file against a detached
# signature. If the signature cannot be verified, the recipe exits with
# error.
#
# ARGUMENTS
# <signature>
# The detached signature file to use.
#
# <signed_file>
# The signed file to verify.

ifndef verify_sig

define verify_sig
gpg --verify $(1) $(2)
endef

endif
