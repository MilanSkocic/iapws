/**
* @file
* @brief Version
*/

#ifndef iapws_VERSION_H
#define iapws_VERSION_H
#if _MSC_VER
#define ADD_IMPORT __declspec(dllimport)
#else
#define ADD_IMPORT
#endif
extern char* capi_get_version(void);
#endif

