#!/bin/ksh -p
# SPDX-License-Identifier: CDDL-1.0
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or https://opensource.org/licenses/CDDL-1.0.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

#
# Copyright (c) 2013 by Delphix. All rights reserved.
#
. $STF_SUITE/include/libtest.shlib
. $STF_SUITE/tests/functional/userquota/userquota_common.kshlib

#
#
# DESCRIPTION:
#       Check whether chattr works as expected
#
#
# STRATEGY:
#       1. Create 3 files
#       2. Use chattr to make them writable, immutable and appendonly
#       3. Try to write and append to each file
#

set -A files writable immutable append

function cleanup
{
	for i in ${files[*]}; do
		if is_freebsd ; then
			log_must chflags noschg $TESTDIR/$i
			log_must rm -f $TESTDIR/$i
		else
			log_must chattr -ia $TESTDIR/$i
			log_must rm -f $TESTDIR/$i
		fi
	done
}

log_onexit cleanup

if is_freebsd ; then
	log_assert "Check whether chflags works as expected"
else
	log_assert "Check whether chattr works as expected"
fi

log_must touch $TESTDIR/writable
log_must touch $TESTDIR/immutable
log_must touch $TESTDIR/append

if is_freebsd ; then
	log_must chflags noschg $TESTDIR/writable
	log_must chflags schg $TESTDIR/immutable
	log_must chflags sappnd $TESTDIR/append
else
	log_must chattr -i $TESTDIR/writable
	log_must chattr +i $TESTDIR/immutable
	log_must chattr +a $TESTDIR/append
fi

log_must eval "echo test > $TESTDIR/writable"
log_must eval "echo test >> $TESTDIR/writable"
log_mustnot eval "echo test > $TESTDIR/immutable"
log_mustnot eval "echo test >> $TESTDIR/immutable"
log_mustnot eval "echo test > $TESTDIR/append"
log_must eval "echo test >> $TESTDIR/append"

if is_freebsd ; then
	log_pass "chflags works as expected"
else
	log_pass "chattr works as expected"
fi
