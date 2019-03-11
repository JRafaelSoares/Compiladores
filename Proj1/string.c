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

int main() {
	char* coco = "";
	char* xixi = "as";
	printf("%d\n", strcmp(coco,xixi));

	char* des = (char *) malloc(sizeof(char)*5);

	printf("%s\n", strcpy(des, xixi));

	xixi = "asd";

	printf("%s\n", xixi);
	return 0;
}

