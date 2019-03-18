#include <stdio.h>
#include <stdlib.h>
int strcmp(const char *str1, const char *str2){

	int i = -1;

	do {
		i++;		
		if(str1[i] > str2[i]) {
			return 1;
		}
		else if(str1[i] < str2[i]) {
			return -1;
		}	
	} while(str1[i] != '\0' && str2[i] != '\0');
	return 0;
} 

char *strcpy(char *dest, const char *src) {

	int i = -1;
	do {
		i++;
		dest[i] = src[i];
	} while(src[i] != '\0');
	return dest;
}

char *strchr(const char *str, int c) {
	while(*str != (char)c){
		if (!*str++)
			return 0;
	}
	return (char *)str;
}
int main() {
	const char xixi[] = "Ola o meu nome e Rafael";
	const char coco[] = "Ola o meu nome e Rafael";

	char *ret;
	printf("%d\n", strcmp(xixi, coco));

	return 0;
}

