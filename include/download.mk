# RECIPE
# download - download a file from a URL
#
# USAGE
# $(call download,<url>,<filename>)
#
# DESCRIPTION
# The "download" recipe downloads a file from a URL. If the download
# fails the <filename> file is deleted and the recipe exits with error.
#
# ARGUMENTS
# <url>
# The URL to download from.
#
# <filename>
# The name of the file to download to.

ifndef download

define download
curl -sLfo $(2) $(1) || (rm -f $(2) && exit 1)
endef

endif
