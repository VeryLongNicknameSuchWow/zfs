// SPDX-License-Identifier: CDDL-1.0
/*
 * CDDL HEADER START
 *
 * This file and its contents are supplied under the terms of the
 * Common Development and Distribution License ("CDDL"), version 1.0.
 * You may only use this file in accordance with the terms of version
 * 1.0 of the CDDL.
 *
 * A full copy of the text of the CDDL should have accompanied this
 * source.  A copy of the CDDL is also available via the Internet at
 * http://www.illumos.org/license/CDDL.
 *
 * CDDL HEADER END
 */
/*
 * Copyright (c) 2014, 2018 by Delphix. All rights reserved.
 */

#ifndef	_BQUEUE_H
#define	_BQUEUE_H

#ifdef	__cplusplus
extern "C" {
#endif

#include	<sys/zfs_context.h>

typedef struct bqueue {
	list_t bq_list;
	size_t bq_size;
	list_t bq_dequeuing_list;
	size_t bq_dequeuing_size;
	list_t bq_enqueuing_list;
	size_t bq_enqueuing_size;
	kmutex_t bq_lock;
	kcondvar_t bq_add_cv;
	kcondvar_t bq_pop_cv;
	size_t bq_maxsize;
	uint_t bq_fill_fraction;
	size_t bq_node_offset;
} bqueue_t;

typedef struct bqueue_node {
	list_node_t bqn_node;
	size_t bqn_size;
} bqueue_node_t;


int bqueue_init(bqueue_t *, uint_t, size_t, size_t);
void bqueue_destroy(bqueue_t *);
void bqueue_enqueue(bqueue_t *, void *, size_t);
void bqueue_enqueue_flush(bqueue_t *, void *, size_t);
void *bqueue_dequeue(bqueue_t *);

#ifdef	__cplusplus
}
#endif

#endif	/* _BQUEUE_H */
