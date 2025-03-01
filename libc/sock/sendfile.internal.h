#ifndef COSMOPOLITAN_LIBC_SOCK_SENDFILE_INTERNAL_H_
#define COSMOPOLITAN_LIBC_SOCK_SENDFILE_INTERNAL_H_
#if !(__ASSEMBLER__ + __LINKER__ + 0)
COSMOPOLITAN_C_START_

int sys_sendfile_xnu(int32_t infd, int32_t outfd, int64_t offset,
                     int64_t *out_opt_sbytes, const void *opt_hdtr,
                     int32_t flags) _Hide;

int sys_sendfile_freebsd(int32_t infd, int32_t outfd, int64_t offset,
                         size_t nbytes, const void *opt_hdtr,
                         int64_t *out_opt_sbytes, int32_t flags) _Hide;

COSMOPOLITAN_C_END_
#endif /* !(__ASSEMBLER__ + __LINKER__ + 0) */
#endif /* COSMOPOLITAN_LIBC_SOCK_SENDFILE_INTERNAL_H_ */
