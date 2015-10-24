# RECIPE
# recv_key - download and import cryptographic key
#
# USAGE
# $(call recv_key,<key_id>,[<export_filename>])
#
# DESCRIPTION
# The "recv_key" recipe downloads the cryptographic key identified by
# <key_id> and adds it to the keyring. This is needed to verify
# signatures on other downloaded files.
#
# Providing the optional <export_filename> argument causes recv_key to
# export the downloaded key to the file at <export_filename>. The
# exported key file can then be used as an order-only prerequisite in
# other rules.
#
# ARGUMENTS
# <key_id>
# The ID of the key to download and import.
#
# <export_filename> [OPTIONAL]
# The file name to export the downloaded key to. If <export_filename> is
# not provided, the key is downloaded and imported, and no files are
# generated.

ifndef recv_key

define recv_key
gpg --keyserver keys.gnupg.net --recv-keys $(1)$(if $(2),&& gpg -ao $(2) --export $(1))
endef

endif
