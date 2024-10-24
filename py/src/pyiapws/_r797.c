#define PY_SSIZE_T_CLEAN
#include "_core.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws_r797 module of the Fortran iapws library.");

PyDoc_STRVAR(r797_psat_doc, 
"psat(Ts: array-like) --> mview \n\n"
"Get the saturation-pressure line. If gas not found returns NaNs");

PyDoc_STRVAR(r797_Tsat_doc, 
"Tsat(ps: array-like) --> mview \n\n"
"Get the saturation-temperature line. If gas not found returns NaNs");


static PyObject *r797_psat(PyObject *self, PyObject *args){
    
    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "O", &T_obj)){
        return NULL;
    }

    mview = PyMemoryView_FromObject(T_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);
    newbuffer = newbuffer_like(buffer);
    iapws_r797_psat(buffer->shape[0], (double *) buffer->buf, (double *) newbuffer.buf);
    new_mview = PyMemoryView_FromBuffer(&newbuffer);

    return new_mview;
}

static PyObject *r797_Tsat(PyObject *self, PyObject *args){
    PyObject *p_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "O", &p_obj)){
        return NULL;
    }

    mview = PyMemoryView_FromObject(p_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);
    newbuffer = newbuffer_like(buffer);
    iapws_r797_Tsat(buffer->shape[0], (double *) buffer->buf, (double *) newbuffer.buf);
    new_mview = PyMemoryView_FromBuffer(&newbuffer);

    return new_mview;
}


static PyMethodDef myMethods[] = {
    {"psat", (PyCFunction) r797_psat, METH_VARARGS, r797_psat_doc},
    {"Tsat", (PyCFunction) r797_Tsat, METH_VARARGS, r797_Tsat_doc},
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef _r797 = {
    PyModuleDef_HEAD_INIT,
    "_r797",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit__r797(void)
{
    return PyModule_Create(&_r797);
}


