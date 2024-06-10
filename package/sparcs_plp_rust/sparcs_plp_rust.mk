################################################################################
#
# SPARCS_PLP_RUST (sparcs-plp-rust)
#
################################################################################

SPARCS_PLP_RUST_SITE = $(call qstrip,$(BR2_PACKAGE_SPARCS_PLP_RUST_REPO_URL))
SPARCS_PLP_RUST_SITE_METHOD = git
VERSION = $(call qstrip,$(BR2_PACKAGE_SPARCS_PLP_RUST_REPO_VERSION))



# This was easier to do, pulls the hash from the remote repo and cuts it down to be 7 characters long (same as would come out of git describe)
GIT_HASH = $(shell git ls-remote $(SPARCS_PLP_RUST_SITE) $(VERSION) | cut -f 1 | cut -c1-8 )
SPARCS_PLP_RUST_CARGO_ENV += GIT_DESCRIBE=$(GIT_HASH)

# If the version specified is a branch name, we need to go fetch the SHA1 for the branch's HEAD
ifeq ($(shell git ls-remote --heads $(SPARCS_PLP_RUST_SITE) $(VERSION) | wc -l), 1)
    SPARCS_PLP_RUST_VERSION := $(shell git ls-remote $(SPARCS_PLP_RUST_SITE) $(VERSION) | cut -c1-8)
else
    SPARCS_PLP_RUST_VERSION = $(VERSION)
endif

define SPARCS_PLP_RUST_INSTALL_TARGET_CMDS
    [ -d $(TARGET_DIR)/usr/bin/sparcs ] || mkdir $(TARGET_DIR)/usr/bin/sparcs; \
    [ -d $(TARGET_DIR)/etc/sparcs ] || mkdir $(TARGET_DIR)/etc/sparcs; \
    [ -d $(TARGET_DIR)/etc/sparcs/reference_frames ] || mkdir $(TARGET_DIR)/etc/sparcs/reference_frames; \
    [ -d $(TARGET_DIR)/etc/sparcs/reference_frames/biases ] || mkdir $(TARGET_DIR)/etc/sparcs/reference_frames/biases; \
    [ -d $(TARGET_DIR)/etc/sparcs/reference_frames/darks ] || mkdir $(TARGET_DIR)/etc/sparcs/reference_frames/darks; \
    [ -d $(TARGET_DIR)/etc/sparcs/reference_frames/flats ] || mkdir $(TARGET_DIR)/etc/sparcs/reference_frames/flats; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/boot_counter $(TARGET_DIR)/usr/bin/sparcs/boot_counter; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/command-manager $(TARGET_DIR)/usr/bin/sparcs/command-manager; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/sparcam_bulk_config $(TARGET_DIR)/usr/bin/sparcs/sparcam_bulk_config; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/sparcam_debug $(TARGET_DIR)/usr/bin/sparcs/sparcam_debug; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/sparcam-comm-stats $(TARGET_DIR)/usr/bin/sparcs/sparcam-comm-stats; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/udp-cli $(TARGET_DIR)/usr/bin/sparcs/udp-cli; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/payload-control $(TARGET_DIR)/usr/bin/sparcs/payload-control; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/sci-obs $(TARGET_DIR)/usr/bin/sparcs/sci-obs; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/cfdp $(TARGET_DIR)/usr/bin/sparcs/cfdp; \
    $(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/space-saver $(TARGET_DIR)/usr/bin/sparcs/space-saver; \
    $(INSTALL) -D -m 0755 $(@D)/data/sparcs_payload_configuration.toml $(TARGET_DIR)/etc/sparcs/;\
    $(INSTALL) -D -m 0755 $(@D)/data/thermistor_config.toml $(TARGET_DIR)/etc/sparcs/;\
    $(INSTALL) -D -m 0755 $(@D)/data/master_bias_g1.17.raw.bz2 $(TARGET_DIR)/etc/sparcs/reference_frames/biases/master_bias.raw.bz2;\
    $(INSTALL) -D -m 0755 $(@D)/data/master_dark_T35_g1.17.raw.bz2 $(TARGET_DIR)/etc/sparcs/reference_frames/darks/master_dark.raw.bz2;
endef

$(eval $(cargo-package))
