#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>
#include <string.h>
#include "iapws_g704.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws_g704 module of the Fortran iapws library.");

PyDoc_STRVAR(g704_kh_doc, 
"get_kh(T, gas, solvent) --> memview \n\n"
"Get the kh value for gas in solvent for T. If gas not found returns NaN");

PyDoc_STRVAR(g704_kd_doc, 
"get_kd(T, gas, solvent) --> memview \n\n"
"Get the kd value for gas in solvent for T. If gas not found returns NaN");

static const char ERR_MSG_PARSING[] = "T is an object with the buffer protocol, gas is a string, heavywater is a boolean.";
static const char ERR_MSG_T_DIM[] = "T must be a 1d-array of floats.";
static const char ERR_MSG_T_TYPE[] = "T must be a 1d-array of floats.";

static Py_buffer newbuffer_like(Py_buffer *buffer){
    Py_buffer newbuffer;
    newbuffer.buf = PyMem_Malloc(buffer->len);
    newbuffer.obj = NULL;
    newbuffer.len = buffer->len;
    newbuffer.readonly = buffer->readonly;
    newbuffer.itemsize = buffer->itemsize;
    newbuffer.format = buffer->format;
    newbuffer.ndim = buffer->ndim;
    newbuffer.shape = buffer->shape;
    newbuffer.strides = buffer->strides;
    newbuffer.suboffsets = NULL;

    return newbuffer;
}

static PyObject *kx(char k, PyObject *args){
    
    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    char *gas;
    int heavywater;

    void (*fkx)(double *, char *, int, double *, int, size_t);

    switch(k){
        case 'h':
            fkx = &iapws_g704_capi_kh;
            break;
        case 'd':
            fkx = &iapws_g704_capi_kd;
            break;
        default:
            fkx = NULL;
    }
    
    if(!PyArg_ParseTuple(args, "Osp", &T_obj, &gas, &heavywater)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }

    if(PyObject_CheckBuffer(T_obj)==1){
        mview = PyMemoryView_FromObject(T_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_TYPE);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_DIM);
            return NULL;
        }else{
            newbuffer = newbuffer_like(buffer);
            fkx((double *)buffer->buf, gas, heavywater, (double *)newbuffer.buf, strlen(gas), newbuffer.shape[0]);
            new_mview = PyMemoryView_FromBuffer(&newbuffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }
}

static PyObject *g704_kh(PyObject *self, PyObject *args){
    return kx('h', args);
}

static PyObject *g704_kd(PyObject *self, PyObject *args){
    return kx('d', args);
}

static PyMethodDef myMethods[] = {
    {"kh", (PyCFunction) g704_kh, METH_VARARGS, g704_kh_doc},
    {"kd", (PyCFunction) g704_kd, METH_VARARGS, g704_kd_doc},
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef g704 = {
    PyModuleDef_HEAD_INIT,
    "g704",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit_g704(void)
{
    return PyModule_Create(&g704);
}


