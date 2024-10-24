#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "iapws.h"


PyDoc_STRVAR(module_docstring, "C extension for iapws version.");

static PyMethodDef myMethods[] = {{ NULL, NULL, 0, NULL }};
static struct PyModuleDef _version = {PyModuleDef_HEAD_INIT, "_version", module_docstring, -1, myMethods};

PyMODINIT_FUNC PyInit__version(void){
    PyObject *m;
    PyObject *d;
    PyObject *v;
    m = PyModule_Create(&_version);
    d = PyModule_GetDict(m);
    v = PyUnicode_FromFormat("%s", iapws_get_version());
    PyDict_SetItemString(d, "__version__", v);
    Py_INCREF(v);
    return m;
}
