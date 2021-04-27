/**
 * @file utilities.c
 * @author M. Skocic
 * @brief Functions for assiting computation
 * @date 2021/04/27
 */

#include "utilities.h"

 /**
 * @brief Round with n decimals
 * @param x Value to be rounded
 * @param n Number of decimals
 * @return Rounded x
 */
double roundn(double x, int n){

    return round(x * pow(10, n)) / pow(10, n);

}

/**
 * @brief Find the index of an item in a list of strings.
 * @param item Item to be found in list.
 * @param list List of strings.
 * @param size Size of the list.
 * @return index >0 if item was found or -1 if not found.
 */
int find(char *item, char **list, int size)
{
    int i;
    int index=-1;
    for (i=0;i<size;i++)
    {

        if (strcmp(list[i], item)==0)
        {
            index = i;
            break;

        }

    }
    return index;
}
