#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>
#include <string.h>
#include "iapws.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws_r283 module of the Fortran iapws library.");


static PyMethodDef myMethods[] = {
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef r283 = {
    PyModuleDef_HEAD_INIT,
    "r283",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit_r283(void)
{   
    PyObject *m;
    PyObject *d;
    PyObject *v;

    m = PyModule_Create(&r283);
    d = PyModule_GetDict(m);

    v = PyFloat_FromDouble(iapws_r283_capi_Tc_H2O);
    PyDict_SetItemString(d, "Tc_H2O", v);
    Py_INCREF(v);
    v = PyFloat_FromDouble(iapws_r283_capi_Tc_D2O);
    PyDict_SetItemString(d, "Tc_D2O", v);
    Py_INCREF(v);
    
    v = PyFloat_FromDouble(iapws_r283_capi_pc_H2O);
    PyDict_SetItemString(d, "pc_H2O", v);
    Py_INCREF(v);
    v = PyFloat_FromDouble(iapws_r283_capi_pc_D2O);
    PyDict_SetItemString(d, "pc_D2O", v);
    Py_INCREF(v);
    
    v = PyFloat_FromDouble(iapws_r283_capi_rhoc_H2O);
    PyDict_SetItemString(d, "rhoc_H2O", v);
    Py_INCREF(v);
    v = PyFloat_FromDouble(iapws_r283_capi_rhoc_D2O);
    PyDict_SetItemString(d, "rhoc_D2O", v);
    Py_INCREF(v);
    

    return m;
}


