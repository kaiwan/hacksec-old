/*
 * int_of.c
 * Integer Overflow !

 * Author(s) : 
 * Kaiwan N Billimoria
 *  <kaiwan -at- kaiwantech -dot- com>
 * License(s): MIT
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <sys/types.h>

int main (int argc, char **argv)
{
	int idx, myarr[] = {10,16,19,22,36};

	if (argc < 2) {
		fprintf(stderr, "Usage: %s check-int-ovflow-or-not[0|1] array-index\n"
		" (our int array has 5 idxements (0-4))\n", argv[0]);
		exit(EXIT_FAILURE);
	}
	idx = atoi(argv[2]);
	printf("[Fyi: idx=%d sz=%lu INT_MAX=%d UINT_MAX=%u]\n", 
		idx, sizeof(myarr)/sizeof(int), INT_MAX, UINT_MAX);

	if (0 == atoi(argv[1])) {
		printf("Bypassing integer bounds check...\n");
	} else {
		printf("Checking integer bounds now...\n");
		if (idx < 0 || idx >= (sizeof(myarr)/sizeof(int))) {
			fprintf(stderr, "%s: array-index is %d: bad! Aborting...\n",
				argv[0], idx);
			exit(EXIT_FAILURE);
		}
	}
	printf("Element: %d\n", myarr[idx]);
	exit (EXIT_SUCCESS);
}
