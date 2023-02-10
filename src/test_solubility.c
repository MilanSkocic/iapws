/**
 * @file test_solubility.c
 * @brief Test library functions.
 * 
 * @details Test water and heavywater formulas
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
#include <stdlib.h>
#include "iapws.h"



int main(int argc, char **argv){
    
    int res = 0;
    res = test_water();

    res = test_heavywater();
    
    return EXIT_SUCCESS;
}





