/*-*- mode:c;indent-tabs-mode:nil;c-basic-offset:2;tab-width:8;coding:utf-8 -*-│
│vi: set net ft=c ts=2 sts=2 sw=2 fenc=utf-8                                :vi│
╞══════════════════════════════════════════════════════════════════════════════╡
│ Copyright 2020 Justine Alexandra Roberts Tunney                              │
│                                                                              │
│ Permission to use, copy, modify, and/or distribute this software for         │
│ any purpose with or without fee is hereby granted, provided that the         │
│ above copyright notice and this permission notice appear in all copies.      │
│                                                                              │
│ THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL                │
│ WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED                │
│ WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE             │
│ AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL         │
│ DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR        │
│ PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER               │
│ TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR             │
│ PERFORMANCE OF THIS SOFTWARE.                                                │
╚─────────────────────────────────────────────────────────────────────────────*/
#include "libc/calls/struct/sigset.h"
#include "libc/sysv/consts/limits.h"
#include "libc/sysv/errfuns.h"

/**
 * Returns true if signal is member of set.
 *
 * @return 1 if set, 0 if not set, or -1 w/ errno
 * @raises EINVAL if `1 ≤ sig ≤ NSIG` isn't the case
 * @asyncsignalsafe
 * @vforksafe
 */
int sigismember(const sigset_t *set, int sig) {
  _Static_assert(sizeof(set->__bits[0]) * CHAR_BIT == 64, "");
  if (1 <= sig && sig <= NSIG) {
    if (1 <= sig && sig <= _NSIG) {
      return !!(set->__bits[(sig - 1) >> 6] & (1ull << ((sig - 1) & 63)));
    } else {
      return 0;
    }
  } else {
    return einval();
  }
}
