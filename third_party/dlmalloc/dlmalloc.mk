#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#───vi: set et ft=make ts=8 tw=8 fenc=utf-8 :vi───────────────────────┘

PKGS += THIRD_PARTY_DLMALLOC

THIRD_PARTY_DLMALLOC_ARTIFACTS += THIRD_PARTY_DLMALLOC_A
THIRD_PARTY_DLMALLOC = $(THIRD_PARTY_DLMALLOC_A_DEPS) $(THIRD_PARTY_DLMALLOC_A)
THIRD_PARTY_DLMALLOC_A = o/$(MODE)/third_party/dlmalloc/dlmalloc.a
THIRD_PARTY_DLMALLOC_A_FILES := $(wildcard third_party/dlmalloc/*)
THIRD_PARTY_DLMALLOC_A_HDRS = $(filter %.h,$(THIRD_PARTY_DLMALLOC_A_FILES))
THIRD_PARTY_DLMALLOC_A_INCS = $(filter %.inc,$(THIRD_PARTY_DLMALLOC_A_FILES))
THIRD_PARTY_DLMALLOC_A_SRCS_S = $(filter %.S,$(THIRD_PARTY_DLMALLOC_A_FILES))
THIRD_PARTY_DLMALLOC_A_SRCS_C = $(filter %.c,$(THIRD_PARTY_DLMALLOC_A_FILES))

THIRD_PARTY_DLMALLOC_A_SRCS =					\
	$(THIRD_PARTY_DLMALLOC_A_SRCS_S)			\
	$(THIRD_PARTY_DLMALLOC_A_SRCS_C)

THIRD_PARTY_DLMALLOC_A_OBJS =					\
	$(THIRD_PARTY_DLMALLOC_A_SRCS_S:%.S=o/$(MODE)/%.o)	\
	$(THIRD_PARTY_DLMALLOC_A_SRCS_C:%.c=o/$(MODE)/%.o)

THIRD_PARTY_DLMALLOC_A_CHECKS =					\
	$(THIRD_PARTY_DLMALLOC_A).pkg				\
	$(THIRD_PARTY_DLMALLOC_A_HDRS:%=o/$(MODE)/%.ok)

THIRD_PARTY_DLMALLOC_A_DIRECTDEPS =				\
	LIBC_CALLS						\
	LIBC_INTRIN						\
	LIBC_FMT						\
	LIBC_NEXGEN32E						\
	LIBC_RUNTIME						\
	LIBC_STR						\
	LIBC_STUBS						\
	LIBC_SYSV						\
	LIBC_SYSV_CALLS						\
	THIRD_PARTY_COMPILER_RT					\
	THIRD_PARTY_NSYNC

THIRD_PARTY_DLMALLOC_A_DEPS :=					\
	$(call uniq,$(foreach x,$(THIRD_PARTY_DLMALLOC_A_DIRECTDEPS),$($(x))))

$(THIRD_PARTY_DLMALLOC_A):					\
		third_party/dlmalloc/				\
		$(THIRD_PARTY_DLMALLOC_A).pkg			\
		$(THIRD_PARTY_DLMALLOC_A_OBJS)

$(THIRD_PARTY_DLMALLOC_A).pkg:					\
		$(THIRD_PARTY_DLMALLOC_A_OBJS)			\
		$(foreach x,$(THIRD_PARTY_DLMALLOC_A_DIRECTDEPS),$($(x)_A).pkg)

ifneq ($(MODE),tiny)
ifneq ($(MODE),tinylinux)
# README file recommends -O3
# It does double performance in default mode
o/$(MODE)/third_party/dlmalloc/dlmalloc.o: private		\
		OVERRIDE_CFLAGS +=				\
			-O3
endif
endif

# we can't use address sanitizer because:
#   address sanitizer depends on dlmalloc
o/$(MODE)/third_party/dlmalloc/dlmalloc.o: private		\
		OVERRIDE_CFLAGS +=				\
			-ffreestanding				\
			-fno-sanitize=address

# we must segregate codegen because:
#   file contains multiple independently linkable apis
o/$(MODE)/third_party/dlmalloc/dlmalloc.o: private		\
		OVERRIDE_CFLAGS +=				\
			-ffunction-sections			\
			-fdata-sections

THIRD_PARTY_DLMALLOC_LIBS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)))
THIRD_PARTY_DLMALLOC_SRCS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_SRCS))
THIRD_PARTY_DLMALLOC_HDRS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_HDRS))
THIRD_PARTY_DLMALLOC_INCS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_INCS))
THIRD_PARTY_DLMALLOC_BINS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_BINS))
THIRD_PARTY_DLMALLOC_CHECKS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_CHECKS))
THIRD_PARTY_DLMALLOC_OBJS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_OBJS))
THIRD_PARTY_DLMALLOC_TESTS = $(foreach x,$(THIRD_PARTY_DLMALLOC_ARTIFACTS),$($(x)_TESTS))
$(THIRD_PARTY_DLMALLOC_OBJS): $(BUILD_FILES) third_party/dlmalloc/dlmalloc.mk

.PHONY: o/$(MODE)/third_party/dlmalloc
o/$(MODE)/third_party/dlmalloc: $(THIRD_PARTY_DLMALLOC_CHECKS)
