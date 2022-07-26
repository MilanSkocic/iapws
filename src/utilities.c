/**
 * @file utilities.c
 * @author M. Skocic
 * @brief Functions for assiting computation
 * 
 * Provides functions for assisting the main computations.
 * 
 * Copyright (C) 2020-2022  Milan Skocic.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. 
 *
 *
 * Author: Milan Skocic <milan.skocic@icloud.com>
 *
 */
#include <string.h>
#include <math.h>
#include "utilities.h"

 /**
 * @brief Round with n decimals
 * @param x Value to be rounded
 * @param n Number of decimals
 * @return Rounded x
 */
double roundn(double x, int n){

    double fac;
    double rounded_x;
    fac = pow(10, n);
    rounded_x = round(x*fac)/fac;
    return rounded_x;

}

/**
 * @brief Find the index of an item in a list of strings.
 * @param item Item to be found in list.
 * @param list List of strings.
 * @param size Size of the list.
 * @return index >0 if item was found or -1 if not found.
 */
int find(char *item, const char **list, int size)
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
