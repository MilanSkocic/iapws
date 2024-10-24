#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>
#include <string.h>
#include "iapws.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws_r797 module of the Fortran iapws library.");

PyDoc_STRVAR(r797_psat_doc, 
"psat(Ts: array) --> mview \n\n"
"Get the saturation-pressure line. If gas not found returns NaNs");

PyDoc_STRVAR(r797_Tsat_doc, 
"Tsat(ps: array) --> mview \n\n"
"Get the saturation-temperature line. If gas not found returns NaNs");

static const char ERR_MSG_PARSING[] = "Ts is an object with the buffer protocol.";
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


static PyObject *r797_psat(PyObject *self, PyObject *args){
    
    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "O", &T_obj)){
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
        }else if(buffer->ndim==0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_DIM);
            return NULL;
        }else{
            newbuffer = newbuffer_like(buffer);
            iapws_r797_psat(buffer->shape[0], (double *) buffer->buf, (double *) newbuffer.buf);
            new_mview = PyMemoryView_FromBuffer(&newbuffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }
}

static PyObject *r797_Tsat(PyObject *self, PyObject *args){
    PyObject *p_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "O", &p_obj)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }
    if(PyObject_CheckBuffer(p_obj)==1){
        mview = PyMemoryView_FromObject(p_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_TYPE);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_DIM);
            return NULL;
        }else if(buffer->ndim==0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_DIM);
            return NULL;
        }else{
            newbuffer = newbuffer_like(buffer);
            iapws_r797_Tsat(buffer->shape[0], (double *) buffer->buf, (double *) newbuffer.buf);
            new_mview = PyMemoryView_FromBuffer(&newbuffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }
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


